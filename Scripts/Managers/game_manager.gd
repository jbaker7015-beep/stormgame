extends Node

## Match-flow singleton. S1: daily seed + season for atmosphere grid.

const ClimateConfig = preload("res://Systems/Config/climate_zone_config.gd")

signal player_registered(player: Node2D)
signal day_seed_changed(seed_value: int)

var player: Node2D = null
var is_paused: bool = false
var day_seed: int = 0
var season: ClimateConfig.Season = ClimateConfig.Season.SUMMER


func _ready() -> void:
	if day_seed == 0:
		roll_new_day()


func register_player(new_player: Node2D) -> void:
	player = new_player
	player_registered.emit(player)


func get_player_stats() -> Node:
	if player == null:
		return null
	return player.get_node_or_null("Stats")


func roll_new_day() -> void:
	day_seed = randi()
	season = (randi() % 4) as ClimateConfig.Season
	day_seed_changed.emit(day_seed)
	if has_node("/root/AtmosphereGrid"):
		get_node("/root/AtmosphereGrid").set_day(day_seed, season)
