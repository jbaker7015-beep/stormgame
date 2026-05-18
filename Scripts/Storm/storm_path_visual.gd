extends Node2D

## Ghost line for planned / drafting storm path (S2).

const _DRAFT_COLOR := Color(0.55, 0.85, 1.0, 0.45)
const _ACTIVE_COLOR := Color(0.35, 0.95, 1.0, 0.75)
const _TARGET_COLOR := Color(1.0, 0.95, 0.5, 0.9)


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var host: Node = get_parent()
	if host == null or not host.has_method("get_path_draw_state"):
		return
	var state: Dictionary = host.get_path_draw_state()
	var draft: PackedVector2Array = state.get("draft", PackedVector2Array())
	var active: PackedVector2Array = state.get("active", PackedVector2Array())
	var target: Vector2 = state.get("target", Vector2.ZERO)
	var has_target: bool = state.get("has_target", false)

	if draft.size() >= 2:
		_draw_line(draft[0], draft[1], _DRAFT_COLOR, 2.0)
	if active.size() >= 2:
		_draw_line(active[0], active[1], _ACTIVE_COLOR, 3.0)
	if has_target:
		draw_circle(target, 10.0, _TARGET_COLOR)
		draw_arc(target, 14.0, 0.0, TAU, 24, _TARGET_COLOR, 1.5)


func _draw_line(from_global: Vector2, to_global: Vector2, color: Color, width: float) -> void:
	draw_line(to_local(from_global), to_local(to_global), color, width)
	# Heading tick at end of drag.
	var dir: Vector2 = (to_global - from_global).normalized()
	if dir.length_squared() > 0.01:
		var tip: Vector2 = to_local(to_global)
		var wing: Vector2 = Vector2(-dir.y, dir.x) * 8.0
		draw_line(tip, tip - dir * 14.0 + wing, color, width)
		draw_line(tip, tip - dir * 14.0 - wing, color, width)
