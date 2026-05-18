class_name MoisturePocketStats
extends Node

## Atmospheric resources and evolution stages (Prototype Phase 4).

const EvoData = preload("res://Systems/Data/evolution_stage_data.gd")

enum GrowthStage {
	MOISTURE_POCKET,
	UNSTABLE_AIR,
	UPDRAFT_FORMING,
	CUMULUS_CLOUD,
	DEVELOPING_THUNDERSTORM,
}

signal stats_changed(
	humidity: float,
	heat_energy: float,
	storm_energy: float,
	instability: float
)
signal growth_stage_changed(stage: GrowthStage)
signal evolution_progress_changed(progress: float, next_stage_label: String)

var humidity: float = 0.0
var heat_energy: float = 0.0
var storm_energy: float = 0.0
var instability: float = 0.0
var active_biome_label: String = ""
var evolution_progress: float = 0.0

var _zone_humidity_rate: float = 0.0
var _zone_heat_rate: float = 0.0
var _zone_instability_rate: float = 0.0
var _humidity_zone_count: int = 0
var _heat_zone_count: int = 0
var _growth_stage: GrowthStage = GrowthStage.MOISTURE_POCKET
var _active_biomes: Dictionary = {}


func _ready() -> void:
	_emit_stats()


func _process(delta: float) -> void:
	_apply_zone_collection(delta)
	_apply_passive_decay(delta)
	_update_instability(delta)
	_update_storm_energy(delta)
	_refresh_growth_stage()
	_emit_stats()


func add_zone_contribution(
	humidity_rate: float,
	heat_rate: float,
	instability_rate: float,
	biome_label: String
) -> void:
	_zone_humidity_rate += humidity_rate
	_zone_heat_rate += heat_rate
	_zone_instability_rate += instability_rate
	if humidity_rate > 0.0:
		_humidity_zone_count += 1
	if heat_rate > 0.0:
		_heat_zone_count += 1
	_active_biomes[biome_label] = int(_active_biomes.get(biome_label, 0)) + 1
	_refresh_active_biome_label()


func remove_zone_contribution(
	humidity_rate: float,
	heat_rate: float,
	instability_rate: float,
	biome_label: String
) -> void:
	_zone_humidity_rate = maxf(_zone_humidity_rate - humidity_rate, 0.0)
	_zone_heat_rate = maxf(_zone_heat_rate - heat_rate, 0.0)
	_zone_instability_rate = maxf(_zone_instability_rate - instability_rate, 0.0)
	if humidity_rate > 0.0:
		_humidity_zone_count = maxi(_humidity_zone_count - 1, 0)
	if heat_rate > 0.0:
		_heat_zone_count = maxi(_heat_zone_count - 1, 0)
	if _active_biomes.has(biome_label):
		_active_biomes[biome_label] = int(_active_biomes[biome_label]) - 1
		if _active_biomes[biome_label] <= 0:
			_active_biomes.erase(biome_label)
	_refresh_active_biome_label()


func is_in_humidity_zone() -> bool:
	return _humidity_zone_count > 0


func is_in_heat_zone() -> bool:
	return _heat_zone_count > 0


func is_in_any_zone() -> bool:
	return _humidity_zone_count > 0 or _heat_zone_count > 0


func get_energy_ratio() -> float:
	return storm_energy / PrototypeBalance.MAX_STORM_ENERGY


func get_instability_ratio() -> float:
	return instability / PrototypeBalance.MAX_INSTABILITY


func get_growth_stage() -> GrowthStage:
	return _growth_stage


func get_growth_stage_label() -> String:
	return EvoData.get_stage_label(_to_data_stage(_growth_stage))


func get_next_stage_label() -> String:
	return EvoData.get_next_stage_label(_to_data_stage(_growth_stage))


func get_evolution_progress() -> float:
	return evolution_progress


func _to_data_stage(stage: GrowthStage) -> int:
	match stage:
		GrowthStage.UNSTABLE_AIR:
			return EvoData.Stage.UNSTABLE_AIR
		GrowthStage.UPDRAFT_FORMING:
			return EvoData.Stage.WARM_UPDRAFT
		GrowthStage.CUMULUS_CLOUD:
			return EvoData.Stage.CUMULUS_CLOUD
		GrowthStage.DEVELOPING_THUNDERSTORM:
			return EvoData.Stage.DEVELOPING_THUNDERSTORM
		_:
			return EvoData.Stage.MOISTURE_POCKET


func _from_data_stage(stage: int) -> GrowthStage:
	match stage:
		EvoData.Stage.UNSTABLE_AIR:
			return GrowthStage.UNSTABLE_AIR
		EvoData.Stage.WARM_UPDRAFT:
			return GrowthStage.UPDRAFT_FORMING
		EvoData.Stage.CUMULUS_CLOUD:
			return GrowthStage.CUMULUS_CLOUD
		EvoData.Stage.DEVELOPING_THUNDERSTORM:
			return GrowthStage.DEVELOPING_THUNDERSTORM
		_:
			return GrowthStage.MOISTURE_POCKET


func _refresh_active_biome_label() -> void:
	if _active_biomes.is_empty():
		active_biome_label = ""
		return
	var labels: PackedStringArray = PackedStringArray(_active_biomes.keys())
	labels.sort()
	active_biome_label = ", ".join(labels)


func add_humidity(amount: float) -> void:
	humidity = clampf(humidity + amount, 0.0, PrototypeBalance.MAX_HUMIDITY)


func add_heat(amount: float) -> void:
	heat_energy = clampf(heat_energy + amount, 0.0, PrototypeBalance.MAX_HEAT)


func _apply_zone_collection(delta: float) -> void:
	var humidity_mult: float = 1.0
	if _growth_stage == GrowthStage.CUMULUS_CLOUD:
		humidity_mult = PrototypeBalance.CUMULUS_HUMIDITY_MULT
	elif _growth_stage == GrowthStage.DEVELOPING_THUNDERSTORM:
		humidity_mult = PrototypeBalance.CUMULUS_HUMIDITY_MULT * 1.05

	if _zone_humidity_rate > 0.0:
		add_humidity(_zone_humidity_rate * humidity_mult * delta)
	if _zone_heat_rate > 0.0:
		add_heat(_zone_heat_rate * delta)


func _apply_passive_decay(delta: float) -> void:
	if not is_in_humidity_zone() and humidity > 0.0:
		humidity = maxf(humidity - PrototypeBalance.HUMIDITY_DECAY_RATE * delta, 0.0)
	if not is_in_heat_zone() and heat_energy > 0.0:
		heat_energy = maxf(heat_energy - PrototypeBalance.HEAT_DECAY_RATE * delta, 0.0)
	if not is_in_any_zone() and instability > 0.0:
		instability = maxf(
			instability - PrototypeBalance.INSTABILITY_DECAY_RATE * 1.5 * delta,
			0.0
		)
	if (not is_in_humidity_zone() or not is_in_heat_zone()) and storm_energy > 0.0:
		storm_energy = maxf(
			storm_energy - PrototypeBalance.STORM_ENERGY_DECAY_RATE * delta,
			0.0
		)


func _update_instability(delta: float) -> void:
	if not is_in_any_zone():
		return

	var synergy: float = minf(humidity, heat_energy) / PrototypeBalance.MAX_HUMIDITY
	var imbalance: float = absf(humidity - heat_energy) / PrototypeBalance.MAX_HUMIDITY
	var inst_mult: float = 1.0
	if _growth_stage == GrowthStage.UNSTABLE_AIR:
		inst_mult = PrototypeBalance.UNSTABLE_INSTABILITY_MULT
	elif _growth_stage == GrowthStage.DEVELOPING_THUNDERSTORM:
		inst_mult = PrototypeBalance.THUNDERSTORM_INSTABILITY_MULT

	if synergy >= PrototypeBalance.INSTABILITY_SYNERGY_MIN:
		instability += (
			synergy * PrototypeBalance.INSTABILITY_SYNERGY_RATE * inst_mult
			- imbalance * PrototypeBalance.INSTABILITY_IMBALANCE_PENALTY
		) * delta

	if (
		is_in_humidity_zone()
		and is_in_heat_zone()
		and humidity >= PrototypeBalance.INSTABILITY_HIGH_RESOURCE_THRESHOLD
		and heat_energy >= PrototypeBalance.INSTABILITY_HIGH_RESOURCE_THRESHOLD
	):
		instability += PrototypeBalance.INSTABILITY_HIGH_RESOURCE_BONUS * delta

	instability += _zone_instability_rate * delta
	instability = clampf(instability, 0.0, PrototypeBalance.MAX_INSTABILITY)


func _update_storm_energy(delta: float) -> void:
	if not is_in_humidity_zone() or not is_in_heat_zone():
		return
	if humidity <= 1.0 or heat_energy <= 1.0:
		return

	var energy_mult: float = 1.0
	if _growth_stage == GrowthStage.UPDRAFT_FORMING:
		energy_mult = PrototypeBalance.UPDRAFT_ENERGY_MULT
	elif _growth_stage == GrowthStage.CUMULUS_CLOUD:
		energy_mult = PrototypeBalance.CUMULUS_ENERGY_MULT
	elif _growth_stage == GrowthStage.DEVELOPING_THUNDERSTORM:
		energy_mult = PrototypeBalance.THUNDERSTORM_ENERGY_MULT

	var blend: float = minf(humidity, heat_energy) / PrototypeBalance.MAX_HUMIDITY
	var instability_boost: float = 1.0 + get_instability_ratio() * PrototypeBalance.ENERGY_INSTABILITY_BOOST
	storm_energy += (
		PrototypeBalance.ENERGY_SYNTHESIS_RATE * blend * instability_boost * energy_mult * delta
	)
	storm_energy = clampf(storm_energy, 0.0, PrototypeBalance.MAX_STORM_ENERGY)


func _refresh_growth_stage() -> void:
	var data_stage: int = EvoData.evaluate_stage(storm_energy, instability, humidity)
	var new_stage: GrowthStage = _from_data_stage(data_stage)
	var new_progress: float = EvoData.get_progress_toward_next(
		data_stage, storm_energy, instability, humidity
	)
	var next_label: String = EvoData.get_next_stage_label(data_stage)

	if new_stage != _growth_stage:
		_growth_stage = new_stage
		growth_stage_changed.emit(_growth_stage)

	evolution_progress = new_progress
	evolution_progress_changed.emit(evolution_progress, next_label)


func _emit_stats() -> void:
	stats_changed.emit(humidity, heat_energy, storm_energy, instability)
