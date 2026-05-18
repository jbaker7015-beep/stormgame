extends Node2D

## Applies map limits to the player camera after the scene tree is ready.


func _ready() -> void:
	call_deferred("_apply_camera_limits")


func _apply_camera_limits() -> void:
	var player: Node2D = GameManager.player
	if player == null:
		return
	var camera: Camera2D = player.get_node_or_null("Camera2D") as Camera2D
	if camera == null:
		return
	camera.limit_left = WorldMapConfig.CAMERA_LIMIT_LEFT
	camera.limit_top = WorldMapConfig.CAMERA_LIMIT_TOP
	camera.limit_right = WorldMapConfig.CAMERA_LIMIT_RIGHT
	camera.limit_bottom = WorldMapConfig.CAMERA_LIMIT_BOTTOM
	camera.limit_smoothed = true
