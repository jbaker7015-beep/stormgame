class_name MoisturePocketStats
extends Node

## Stores atmospheric resources for the player moisture pocket.
## Other systems modify these values through public methods and listen to signals.

signal stats_changed(humidity: float, heat_energy: float, storm_energy: float)

var humidity: float = 0.0
var heat_energy: float = 0.0
var storm_energy: float = 0.0

var _in_humidity_zone: bool = false
var _in_heat_zone: bool = false


func _ready() -> void:
	_emit_stats()


func _process(delta: float) -> void:
	_apply_zone_collection(delta)
	_apply_passive_decay(delta)
	_update_storm_energy(delta)
	_emit_stats()


func set_in_humidity_zone(is_inside: bool) -> void:
	_in_humidity_zone = is_inside


func set_in_heat_zone(is_inside: bool) -> void:
	_in_heat_zone = is_inside


func add_humidity(amount: float) -> void:
	humidity = clampf(humidity + amount, 0.0, PrototypeBalance.MAX_HUMIDITY)


func add_heat(amount: float) -> void:
	heat_energy = clampf(heat_energy + amount, 0.0, PrototypeBalance.MAX_HEAT)


func get_energy_ratio() -> float:
	return storm_energy / PrototypeBalance.MAX_STORM_ENERGY


func _apply_zone_collection(delta: float) -> void:
	if _in_humidity_zone:
		add_humidity(PrototypeBalance.HUMIDITY_GAIN_PER_SECOND * delta)
	if _in_heat_zone:
		add_heat(PrototypeBalance.HEAT_GAIN_PER_SECOND * delta)


func _apply_passive_decay(delta: float) -> void:
	if not _in_humidity_zone and humidity > 0.0:
		humidity = maxf(humidity - PrototypeBalance.HUMIDITY_DECAY_RATE * delta, 0.0)
	if not _in_heat_zone and heat_energy > 0.0:
		heat_energy = maxf(heat_energy - PrototypeBalance.HEAT_DECAY_RATE * delta, 0.0)


func _update_storm_energy(delta: float) -> void:
	# Energy grows when the pocket holds both humidity and heat (synthesis).
	if humidity > 1.0 and heat_energy > 1.0:
		var blend: float = minf(humidity, heat_energy) / PrototypeBalance.MAX_HUMIDITY
		storm_energy += PrototypeBalance.ENERGY_SYNTHESIS_RATE * blend * delta
		storm_energy = clampf(storm_energy, 0.0, PrototypeBalance.MAX_STORM_ENERGY)


func _emit_stats() -> void:
	stats_changed.emit(humidity, heat_energy, storm_energy)
