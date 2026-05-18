extends Control

## HUD for Prototype Phase 4 — resources, evolution stage, and progress.

@onready var _humidity_bar: ProgressBar = %HumidityBar
@onready var _heat_bar: ProgressBar = %HeatBar
@onready var _energy_bar: ProgressBar = %EnergyBar
@onready var _instability_bar: ProgressBar = %InstabilityBar
@onready var _stage_label: Label = %StageLabel
@onready var _evolution_label: Label = %EvolutionLabel
@onready var _evolution_bar: ProgressBar = %EvolutionBar
@onready var _biome_label: Label = %BiomeLabel
@onready var _rivals_label: Label = %RivalsLabel
@onready var _hint_label: Label = %HintLabel


func _ready() -> void:
	_configure_bars()
	GameManager.player_registered.connect(_on_player_registered)
	if GameManager.player != null:
		_on_player_registered(GameManager.player)
	AIManager.ai_storm_registered.connect(_on_ai_ecosystem_changed)
	AIManager.ai_storm_unregistered.connect(_on_ai_ecosystem_changed)
	_update_rivals_label()


func _configure_bars() -> void:
	_humidity_bar.max_value = PrototypeBalance.MAX_HUMIDITY
	_heat_bar.max_value = PrototypeBalance.MAX_HEAT
	_energy_bar.max_value = PrototypeBalance.MAX_STORM_ENERGY
	_instability_bar.max_value = PrototypeBalance.MAX_INSTABILITY
	_evolution_bar.max_value = 100.0


func _on_player_registered(player: Node2D) -> void:
	var stats: Node = player.get_node_or_null("Stats")
	if stats == null:
		return
	stats.stats_changed.connect(_on_stats_changed)
	stats.growth_stage_changed.connect(_on_growth_stage_changed)
	stats.evolution_progress_changed.connect(_on_evolution_progress_changed)
	_on_stats_changed(stats.humidity, stats.heat_energy, stats.storm_energy, stats.instability)
	_on_growth_stage_changed(stats.get_growth_stage())
	_on_evolution_progress_changed(stats.get_evolution_progress(), stats.get_next_stage_label())


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


func _on_evolution_progress_changed(progress: float, next_label: String) -> void:
	_evolution_bar.value = progress * 100.0
	if progress >= 0.999 and next_label.contains("Peak"):
		_evolution_label.text = "Evolution: %s" % next_label
	else:
		_evolution_label.text = "Toward %s: %d%%" % [next_label, int(progress * 100.0)]


func _apply_stage_color(stage: int) -> void:
	match stage:
		MoisturePocketStats.GrowthStage.MATURE_THUNDERSTORM:
			_stage_label.modulate = Color(0.72, 0.68, 1.0)
		MoisturePocketStats.GrowthStage.DEVELOPING_THUNDERSTORM:
			_stage_label.modulate = Color(0.82, 0.78, 1.0)
		MoisturePocketStats.GrowthStage.CUMULUS_CLOUD:
			_stage_label.modulate = Color(0.92, 0.96, 1.0)
		MoisturePocketStats.GrowthStage.UPDRAFT_FORMING:
			_stage_label.modulate = Color(1.0, 0.88, 0.55)
		MoisturePocketStats.GrowthStage.UNSTABLE_AIR:
			_stage_label.modulate = Color(0.85, 0.75, 1.0)
		_:
			_stage_label.modulate = Color(0.9, 0.95, 1.0)


func _on_ai_ecosystem_changed(_ai_storm: Node2D) -> void:
	_update_rivals_label()


func _update_rivals_label() -> void:
	var count: int = AIManager.get_ai_count()
	if count <= 0:
		_rivals_label.text = "Rivals: spawning…"
		return
	var lead: String = AIManager.get_strongest_ai_stage_label()
	_rivals_label.text = "Rivals: %d AI storms (lead: %s)" % [count, lead]


func _update_hint(humidity: float, heat: float, energy: float, instability: float) -> void:
	var stats: Node = GameManager.get_player_stats()
	if stats != null and stats.active_biome_label != "":
		_biome_label.text = "Biome: %s" % stats.active_biome_label
	else:
		_biome_label.text = "Biome: —"

	var in_humid: bool = stats != null and stats.is_in_humidity_zone()
	var in_heat: bool = stats != null and stats.is_in_heat_zone()
	var stage: int = stats.get_growth_stage() if stats != null else 0

	if stage == MoisturePocketStats.GrowthStage.MATURE_THUNDERSTORM:
		_hint_label.text = _movement_hint_prefix() + "Mature Thunderstorm — peak power! Severe rain, wind, lightning, and hail aura."
	elif stage == MoisturePocketStats.GrowthStage.DEVELOPING_THUNDERSTORM:
		_hint_label.text = _movement_hint_prefix() + "Developing Thunderstorm — push stats to reach Mature Thunderstorm."
	elif stage == MoisturePocketStats.GrowthStage.CUMULUS_CLOUD:
		_hint_label.text = _movement_hint_prefix() + "Cumulus Cloud — push energy, instability, and humidity to evolve further."
	elif stage == MoisturePocketStats.GrowthStage.UPDRAFT_FORMING:
		_hint_label.text = _movement_hint_prefix() + "Updraft active — push energy and humidity to reach Cumulus Cloud."
	elif energy >= PrototypeBalance.UPDRAFT_ENERGY and instability >= PrototypeBalance.UPDRAFT_INSTABILITY:
		_hint_label.text = _movement_hint_prefix() + "Severe storm — rain, wind, and lightning active!"
	elif (
		instability >= PrototypeBalance.LIGHTNING_MIN_INSTABILITY
		and energy >= PrototypeBalance.LIGHTNING_MIN_ENERGY
	):
		_hint_label.text = "Charged atmosphere — watch for lightning and wind drift."
	elif energy >= PrototypeBalance.RAIN_MIN_ENERGY and (
		humidity >= PrototypeBalance.RAIN_MIN_HUMIDITY
		or instability >= PrototypeBalance.RAIN_MIN_INSTABILITY
	):
		_hint_label.text = "Rain active — grow evolution progress to advance stages."
	elif energy >= 8.0 or instability >= 15.0:
		_hint_label.text = "Storm building — fill the evolution bar to advance."
	elif in_humid and in_heat:
		_hint_label.text = "Synthesizing energy — stay in overlapping humid + heat zones."
	elif in_humid or in_heat:
		_hint_label.text = "Find a biome with the other resource to grow storm energy."
	elif humidity <= 1.0 and heat <= 1.0:
		_hint_label.text = _movement_hint_prefix() + "Enter colored biomes — AI rivals seek the same resources."
	else:
		_hint_label.text = _movement_hint_prefix() + "Leave biomes — resources decay. Re-enter to grow again."


func _movement_hint_prefix() -> String:
	if PrototypeBalance.LEGACY_WASD_MOVEMENT:
		return ""
	return "Click-drag to plan path · Hold Shift = debug WASD · "

