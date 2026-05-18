extends Node2D

## Spawns AI storm pockets for Prototype Phase 5.

const AI_POCKET_SCENE: PackedScene = preload("res://Scenes/Storms/ai_moisture_pocket.tscn")

@export var spawn_positions: Array[Vector2] = [
	Vector2(420, 440),
	Vector2(920, 260),
	Vector2(540, 280),
]

@export var ai_names: Array[String] = ["AI Alpha", "AI Beta", "AI Gamma"]


func _ready() -> void:
	call_deferred("_spawn_ai_storms")


func _spawn_ai_storms() -> void:
	for i in spawn_positions.size():
		var ai: Node2D = AI_POCKET_SCENE.instantiate()
		if i < ai_names.size() and ai is AIMoisturePocketController:
			(ai as AIMoisturePocketController).ai_display_name = ai_names[i]
		add_child(ai)
		ai.global_position = spawn_positions[i]
