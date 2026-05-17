class_name CameraController
extends Camera2D

## Smooth follow camera with mouse-wheel zoom for readability.

var _zoom_level: float = 1.0


func _ready() -> void:
	_zoom_level = zoom.x
	# When parented to the player, smoothing is handled by the CharacterBody2D.


func _process(delta: float) -> void:
	_handle_zoom_input()
	_apply_zoom(delta)


func _handle_zoom_input() -> void:
	if Input.is_action_just_pressed("camera_zoom_in"):
		_zoom_level = clampf(
			_zoom_level - PrototypeBalance.CAMERA_ZOOM_STEP,
			PrototypeBalance.CAMERA_ZOOM_MIN,
			PrototypeBalance.CAMERA_ZOOM_MAX
		)
	if Input.is_action_just_pressed("camera_zoom_out"):
		_zoom_level = clampf(
			_zoom_level + PrototypeBalance.CAMERA_ZOOM_STEP,
			PrototypeBalance.CAMERA_ZOOM_MIN,
			PrototypeBalance.CAMERA_ZOOM_MAX
		)


func _apply_zoom(delta: float) -> void:
	var target_zoom := Vector2.ONE * _zoom_level
	zoom = zoom.lerp(target_zoom, 1.0 - exp(-12.0 * delta))
