extends Node

## Tracks AI storm entities for ecosystem simulation (Prototype Phase 5).

signal ai_storm_registered(ai_storm: Node2D)
signal ai_storm_unregistered(ai_storm: Node2D)

var ai_storms: Array[Node2D] = []


func register_ai_storm(ai_storm: Node2D) -> void:
	if ai_storm in ai_storms:
		return
	ai_storms.append(ai_storm)
	ai_storm_registered.emit(ai_storm)


func unregister_ai_storm(ai_storm: Node2D) -> void:
	if ai_storm in ai_storms:
		ai_storms.erase(ai_storm)
		ai_storm_unregistered.emit(ai_storm)


func get_ai_count() -> int:
	return ai_storms.size()


func get_strongest_ai_stage_label() -> String:
	var best_stage: int = -1
	var best_label: String = "—"

	for storm in ai_storms:
		if not is_instance_valid(storm):
			continue
		var stats: Node = storm.get_node_or_null("Stats")
		if stats == null:
			continue
		var stage: int = stats.get_growth_stage()
		if stage > best_stage:
			best_stage = stage
			best_label = stats.get_growth_stage_label()

	return best_label
