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
		_draw_polyline(draft, _DRAFT_COLOR, 2.0, true)
	if active.size() >= 2:
		_draw_polyline(active, _ACTIVE_COLOR, 3.0, false)
	if has_target:
		draw_circle(target, 10.0, _TARGET_COLOR)
		draw_arc(target, 14.0, 0.0, TAU, 24, _TARGET_COLOR, 1.5)


func _draw_polyline(points: PackedVector2Array, color: Color, width: float, dashed: bool) -> void:
	for i in range(points.size() - 1):
		if dashed and i % 2 == 1:
			continue
		draw_line(to_local(points[i]), to_local(points[i + 1]), color, width)
