class_name StormTrajectory
extends RefCounted

## Committed route waypoints for S2 trajectory movement.

var waypoints: PackedVector2Array = PackedVector2Array()
var waypoint_index: int = 0


func clear() -> void:
	waypoints = PackedVector2Array()
	waypoint_index = 0


func set_path(points: PackedVector2Array) -> void:
	waypoints = points
	waypoint_index = 0


func has_active_target() -> bool:
	return waypoint_index >= 0 and waypoint_index < waypoints.size()


func get_target() -> Vector2:
	if not has_active_target():
		return Vector2.ZERO
	return waypoints[waypoint_index]


func advance_through(pos: Vector2, arrival_radius: float) -> void:
	while has_active_target() and pos.distance_to(waypoints[waypoint_index]) <= arrival_radius:
		waypoint_index += 1


func is_complete() -> bool:
	return waypoints.size() > 0 and waypoint_index >= waypoints.size()
