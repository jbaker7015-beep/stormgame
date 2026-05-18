extends Node2D

## Brief visual burst when the storm evolves to a new stage (Phase 4).

@onready var _ring: Polygon2D = $TransitionRing
@onready var _stats: Node = get_parent().get_parent().get_node("Stats")

var _pulse_tween: Tween = null
var _last_stage: int = -1


func _ready() -> void:
	_ring.visible = false
	_ring.modulate.a = 0.0
	if _stats != null:
		_last_stage = _stats.get_growth_stage()
		_stats.growth_stage_changed.connect(_on_growth_stage_changed)


func _on_growth_stage_changed(stage: int) -> void:
	if stage > _last_stage:
		_play_evolution_pulse()
	_last_stage = stage


func _play_evolution_pulse() -> void:
	if _pulse_tween != null and _pulse_tween.is_valid():
		_pulse_tween.kill()

	_ring.visible = true
	_ring.scale = Vector2.ONE * 0.6
	_ring.modulate = Color(0.85, 0.95, 1.0, 0.85)

	_pulse_tween = create_tween()
	_pulse_tween.set_parallel(true)
	_pulse_tween.tween_property(
		_ring,
		"scale",
		Vector2.ONE * PrototypeBalance.EVOLUTION_PULSE_SCALE,
		PrototypeBalance.EVOLUTION_PULSE_DURATION
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_pulse_tween.tween_property(
		_ring,
		"modulate:a",
		0.0,
		PrototypeBalance.EVOLUTION_PULSE_DURATION
	).set_ease(Tween.EASE_IN)
	_pulse_tween.finished.connect(_on_pulse_finished)


func _on_pulse_finished() -> void:
	_ring.visible = false
