extends Node2D

## Lightweight visuals: scale the cloud with energy and pulse mist particles.

@onready var _stats: Node = get_parent().get_node("Stats")
@onready var _core: Polygon2D = $Core
@onready var _mist: CPUParticles2D = $MistParticles

var _base_core_color: Color


func _ready() -> void:
	_base_core_color = _core.color
	_stats.stats_changed.connect(_on_stats_changed)
	_on_stats_changed(_stats.humidity, _stats.heat_energy, _stats.storm_energy)


func _on_stats_changed(_humidity: float, _heat: float, storm_energy: float) -> void:
	var ratio: float = storm_energy / PrototypeBalance.MAX_STORM_ENERGY
	var scale_value: float = lerpf(
		PrototypeBalance.MIN_VISUAL_SCALE,
		PrototypeBalance.MAX_VISUAL_SCALE,
		ratio
	)
	scale = Vector2.ONE * scale_value

	# Slightly brighten and increase mist as the pocket grows.
	var energy_tint: float = lerpf(0.75, 1.0, ratio)
	_core.color = _base_core_color * Color(energy_tint, energy_tint, energy_tint, 1.0)
	_mist.amount = int(lerpf(8.0, 28.0, ratio))
