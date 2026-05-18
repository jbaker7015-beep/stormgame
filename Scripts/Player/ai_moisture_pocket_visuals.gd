extends "res://Scripts/Player/moisture_pocket_visuals.gd"

## AI storm visuals — warm tint so AI pockets are easy to spot (Phase 5).

@onready var _name_label: Label = $NameLabel

var _ai_tint: Color = Color(1.05, 0.82, 0.72, 1.0)


func _ready() -> void:
	super._ready()
	var controller: Node = get_parent()
	if controller is AIMoisturePocketController:
		_name_label.text = (controller as AIMoisturePocketController).ai_display_name


func _apply_stage_visuals(
	storm_energy: float = -1.0,
	instability: float = -1.0
) -> void:
	super._apply_stage_visuals(storm_energy, instability)
	_core.color *= _ai_tint
	_outer_halo.color *= Color(1.0, 0.85, 0.75, 1.0)
	if _cumulus_puff.visible:
		_cumulus_puff.color *= Color(1.0, 0.88, 0.78, 1.0)
