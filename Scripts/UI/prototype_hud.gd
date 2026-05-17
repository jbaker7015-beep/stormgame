extends Control

## HUD for Prototype Phase 2 — resources, instability, and growth stage.

@onready var _humidity_bar: ProgressBar = %HumidityBar
@onready var _heat_bar: ProgressBar = %HeatBar
@onready var _energy_bar: ProgressBar = %EnergyBar
@onready var _instability_bar: ProgressBar = %InstabilityBar
@onready var _stage_label: Label = %StageLabel
@onready var _biome_label: Label = %BiomeLabel
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
	_instability_bar.max_value = PrototypeBalance.MAX_INSTABILITY


func _on_player_registered(player: Node2D) -> void:
	var stats: Node = player.get_node_or_null("Stats")
	if stats == null:
		return
	stats.stats_changed.connect(_on_stats_changed)
	stats.growth_stage_changed.connect(_on_growth_stage_changed)
	_on_stats_changed(stats.humidity, stats.heat_energy, stats.storm_energy, stats.instability)
	_stage_label.text = "Stage: %s" % stats.get_growth_stage_label()
	_apply_stage_color(stats.get_growth_stage())


func _on_stats_changed(humidity: float, heat: float, energy: float, instability: float) -> void:
	_humidity_bar.value = humidity
	_heat_bar.value = heat
	_energy_bar.value = energy
	_instability_bar.value = instability
	_update_hint(humidity, heat, energy, instability)


func _on_growth_stage_changed(stage: int) -> void:
	var stats: Node = GameManager.get_player_stats()
	if stats == null:
		return
	_stage_label.text = "Stage: %s" % stats.get_growth_stage_label()
	_apply_stage_color(stage)


func _apply_stage_color(stage: int) -> void:
	match stage:
		MoisturePocketStats.GrowthStage.UPDRAFT_FORMING:
			_stage_label.modulate = Color(1.0, 0.88, 0.55)
		MoisturePocketStats.GrowthStage.UNSTABLE_AIR:
			_stage_label.modulate = Color(0.85, 0.75, 1.0)
		_:
			_stage_label.modulate = Color(0.9, 0.95, 1.0)


func _update_hint(humidity: float, heat: float, energy: float, instability: float) -> void:
	var stats: Node = GameManager.get_player_stats()
	if stats != null and stats.active_biome_label != "":
		_biome_label.text = "Biome: %s" % stats.active_biome_label
	else:
		_biome_label.text = "Biome: —"

	var in_humid: bool = stats != null and stats.is_in_humidity_zone()
	var in_heat: bool = stats != null and stats.is_in_heat_zone()

	if energy >= PrototypeBalance.UPDRAFT_ENERGY and instability >= PrototypeBalance.UPDRAFT_INSTABILITY:
		_hint_label.text = "Severe storm — rain, wind, and lightning active!"
	elif (
		instability >= PrototypeBalance.LIGHTNING_MIN_INSTABILITY
		and energy >= PrototypeBalance.LIGHTNING_MIN_ENERGY
	):
		_hint_label.text = "Charged atmosphere — watch for lightning and wind drift."
	elif humidity >= PrototypeBalance.RAIN_MIN_HUMIDITY and energy >= PrototypeBalance.RAIN_MIN_ENERGY:
		_hint_label.text = "Rain forming — humidity and energy are high enough."
	elif in_humid and in_heat:
		_hint_label.text = "Synthesizing energy — stay in overlapping humid + heat zones."
	elif in_humid or in_heat:
		_hint_label.text = "Find a biome with the other resource to grow storm energy."
	elif humidity <= 1.0 and heat <= 1.0:
		_hint_label.text = "Enter colored biomes to collect humidity and heat."
	else:
		_hint_label.text = "Leave biomes — resources decay. Re-enter to grow again."
