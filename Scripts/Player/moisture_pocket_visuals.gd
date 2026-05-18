extends Node2D

## Per-stage cloud visuals and growth scaling (Prototype Phase 4).

const EvoData = preload("res://Systems/Data/evolution_stage_data.gd")

@onready var _stats: Node = get_parent().get_node("Stats")
@onready var _outer_halo: Polygon2D = $OuterHalo
@onready var _cumulus_puff: Polygon2D = $CumulusPuff
@onready var _thunder_glow: Polygon2D = $ThunderGlow
@onready var _core: Polygon2D = $Core
@onready var _mist: CPUParticles2D = $MistParticles
@onready var _updraft: CPUParticles2D = $UpdraftParticles

var _pulse_time: float = 0.0
var _transition_boost: float = 0.0


func _ready() -> void:
	_stats.stats_changed.connect(_on_stats_changed)
	_stats.growth_stage_changed.connect(_on_growth_stage_changed)
	_on_stats_changed(
		_stats.humidity,
		_stats.heat_energy,
		_stats.storm_energy,
		_stats.instability
	)


func _process(delta: float) -> void:
	_pulse_time += delta
	if _transition_boost > 0.0:
		_transition_boost = maxf(_transition_boost - delta * 2.5, 0.0)

	var instability_ratio: float = _stats.get_instability_ratio()
	if instability_ratio < 0.08:
		_outer_halo.modulate = Color.WHITE
		return

	var pulse: float = 1.0 + sin(_pulse_time * 6.0) * instability_ratio * 0.12
	_outer_halo.modulate = Color(1.15 * pulse, 1.05, 1.2 * pulse, 1.0)


func _on_growth_stage_changed(_stage: int) -> void:
	_transition_boost = 0.35
	_apply_stage_visuals()


func _on_stats_changed(
	_humidity: float,
	_heat: float,
	storm_energy: float,
	instability: float
) -> void:
	_apply_stage_visuals(storm_energy, instability)


func _apply_stage_visuals(
	storm_energy: float = -1.0,
	instability: float = -1.0
) -> void:
	if storm_energy < 0.0:
		storm_energy = _stats.storm_energy
	if instability < 0.0:
		instability = _stats.instability

	var data_stage: int = EvoData.evaluate_stage(
		_stats.storm_energy,
		_stats.instability,
		_stats.humidity
	)
	var preset: Dictionary = EvoData.get_visual_preset(data_stage)

	var energy_ratio: float = storm_energy / PrototypeBalance.MAX_STORM_ENERGY
	var instability_ratio: float = instability / PrototypeBalance.MAX_INSTABILITY
	var resource_blend: float = clampf(energy_ratio * 0.5 + instability_ratio * 0.5, 0.0, 1.0)

	var scale_mult: float = preset.get("scale_mult", 1.0)
	var halo_mult: float = preset.get("halo_mult", 1.0)
	var base_scale: float = lerpf(
		PrototypeBalance.MIN_VISUAL_SCALE,
		PrototypeBalance.MAX_VISUAL_SCALE,
		resource_blend
	)
	scale = Vector2.ONE * base_scale * scale_mult * (1.0 + _transition_boost)

	_outer_halo.scale = Vector2.ONE * halo_mult
	_core.color = preset.get("core_color", Color.WHITE)
	_outer_halo.color = preset.get("halo_color", Color.WHITE)

	_cumulus_puff.visible = preset.get("show_cumulus_puff", false)
	if _cumulus_puff.visible:
		_cumulus_puff.modulate.a = lerpf(0.45, 0.75, resource_blend)

	_thunder_glow.visible = preset.get("show_thunder_glow", false)
	if _thunder_glow.visible:
		var pulse: float = 0.65 + sin(_pulse_time * 8.0) * 0.2
		_thunder_glow.modulate = Color(0.75, 0.7, 1.0, pulse * resource_blend)

	var mist_mult: float = preset.get("mist_mult", 1.0)
	_mist.amount = maxi(1, int(lerpf(10.0, 40.0, resource_blend) * mist_mult))

	if instability_ratio > 0.12:
		_updraft.visible = true
		_updraft.amount = maxi(1, int(lerpf(8.0, 24.0, instability_ratio)))
	else:
		_updraft.visible = false
