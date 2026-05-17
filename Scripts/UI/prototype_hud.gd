extends Control

## Basic HUD for Prototype Phase 1 — shows humidity, heat, and storm energy.

@onready var _humidity_bar: ProgressBar = %HumidityBar
@onready var _heat_bar: ProgressBar = %HeatBar
@onready var _energy_bar: ProgressBar = %EnergyBar
@onready var _hint_label: Label = %HintLabel


func _ready() -> void:
	_configure_bars()
	GameManager.player_registered.connect(_on_player_registered)
	if GameManager.player != null:
		_on_player_registered(GameManager.player)


func _configure_bars() -> void:
	_humidity_bar.max_value = PrototypeBalance.MAX_HUMIDITY
	_heat_bar.max_value = PrototypeBalance.MAX_HEAT
	_energy_bar.max_value = PrototypeBalance.MAX_STORM_ENERGY


func _on_player_registered(player: Node2D) -> void:
	var stats: Node = player.get_node_or_null("Stats")
	if stats == null:
		return
	stats.stats_changed.connect(_on_stats_changed)
	_on_stats_changed(stats.humidity, stats.heat_energy, stats.storm_energy)


func _on_stats_changed(humidity: float, heat: float, energy: float) -> void:
	_humidity_bar.value = humidity
	_heat_bar.value = heat
	_energy_bar.value = energy

	if humidity > 1.0 and heat > 1.0:
		_hint_label.text = "Synthesizing storm energy — stay in blue and orange zones!"
	elif humidity <= 1.0 and heat <= 1.0:
		_hint_label.text = "Move into humidity (blue) and heat (orange) zones."
	else:
		_hint_label.text = "Collect both humidity and heat to grow."
