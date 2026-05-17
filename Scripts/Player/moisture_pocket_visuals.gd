extends Node2D

## Cloud growth visuals — layered halo, mist, updraft shimmer (Prototype Phase 2).

@onready var _stats: Node = get_parent().get_node("Stats")
@onready var _outer_halo: Polygon2D = $OuterHalo
@onready var _core: Polygon2D = $Core
@onready var _mist: CPUParticles2D = $MistParticles
@onready var _updraft: CPUParticles2D = $UpdraftParticles

var _base_core_color: Color
var _base_halo_color: Color
var _pulse_time: float = 0.0


func _ready() -> void:
	_base_core_color = _core.color
	_base_halo_color = _outer_halo.color
	_stats.stats_changed.connect(_on_stats_changed)
	_on_stats_changed(
		_stats.humidity,
		_stats.heat_energy,
		_stats.storm_energy,
		_stats.instability
	)


func _process(delta: float) -> void:
	_pulse_time += delta
	var instability_ratio: float = _stats.get_instability_ratio()
	if instability_ratio < 0.08:
		_outer_halo.modulate = Color.WHITE
		return

	var pulse: float = 1.0 + sin(_pulse_time * 6.0) * instability_ratio * 0.12
	_outer_halo.modulate = Color(1.15 * pulse, 1.05, 1.2 * pulse, 1.0)


func _on_stats_changed(
	_humidity: float,
	_heat: float,
	storm_energy: float,
	instability: float
) -> void:
	var energy_ratio: float = storm_energy / PrototypeBalance.MAX_STORM_ENERGY
	var instability_ratio: float = instability / PrototypeBalance.MAX_INSTABILITY
	var growth_blend: float = clampf(energy_ratio * 0.7 + instability_ratio * 0.3, 0.0, 1.0)

	var scale_value: float = lerpf(
		PrototypeBalance.MIN_VISUAL_SCALE,
		PrototypeBalance.MAX_VISUAL_SCALE,
		growth_blend
	)
	scale = Vector2.ONE * scale_value

	var halo_scale: float = lerpf(1.0, PrototypeBalance.HALO_SCALE_MULTIPLIER, growth_blend)
	_outer_halo.scale = Vector2.ONE * halo_scale

	var energy_tint: float = lerpf(0.72, 1.0, energy_ratio)
	var instability_tint: Color = Color(
		lerpf(1.0, 1.15, instability_ratio),
		lerpf(1.0, 0.92, instability_ratio),
		lerpf(1.0, 1.25, instability_ratio),
		1.0
	)
	_core.color = _base_core_color * Color(energy_tint, energy_tint, energy_tint, 1.0) * instability_tint
	_outer_halo.color = _base_halo_color * Color(1.0, 1.0, 1.0, lerpf(0.35, 0.7, growth_blend))

	_mist.amount = maxi(1, int(lerpf(10.0, 36.0, growth_blend)))

	if instability_ratio > 0.15:
		_updraft.visible = true
		_updraft.amount = maxi(1, int(lerpf(6.0, 20.0, instability_ratio)))
	else:
		_updraft.visible = false
