extends Node

## Lightweight match-flow singleton for Prototype Phase 1.
## Later this will handle pause, menus, and match state.

signal player_registered(player: Node2D)

var player: Node2D = null
var is_paused: bool = false


func register_player(new_player: Node2D) -> void:
	player = new_player
	player_registered.emit(player)


func get_player_stats() -> Node:
	if player == null:
		return null
	return player.get_node_or_null("Stats")
