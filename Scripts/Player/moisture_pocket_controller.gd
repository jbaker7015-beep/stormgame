class_name MoisturePocketController
extends CharacterBody2D

## Smooth top-down movement for the moisture pocket (WASD / arrow keys).

@onready var _stats: Node = $Stats


func _ready() -> void:
	GameManager.register_player(self)


func _physics_process(delta: float) -> void:
	if GameManager.is_paused:
		return

	var input_vector: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)

	if input_vector.length_squared() > 0.0:
		velocity = velocity.move_toward(
			input_vector.normalized() * PrototypeBalance.MOVE_SPEED,
			PrototypeBalance.MOVE_ACCELERATION * delta
		)
	else:
		velocity = velocity.move_toward(
			Vector2.ZERO,
			PrototypeBalance.MOVE_FRICTION * delta
		)

	move_and_slide()
