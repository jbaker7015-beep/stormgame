class_name EvolutionStageData
extends Object

## Data-driven evolution stages — aligned with StormEvolutionTree.md.

enum Stage {
	MOISTURE_POCKET,
	UNSTABLE_AIR,
	WARM_UPDRAFT,
	CUMULUS_CLOUD,
	DEVELOPING_THUNDERSTORM,
}


static func evaluate_stage(energy: float, instability: float, humidity: float) -> Stage:
	if (
		energy >= PrototypeBalance.THUNDERSTORM_ENERGY
		and instability >= PrototypeBalance.THUNDERSTORM_INSTABILITY
		and humidity >= PrototypeBalance.THUNDERSTORM_HUMIDITY
	):
		return Stage.DEVELOPING_THUNDERSTORM
	if (
		energy >= PrototypeBalance.CUMULUS_ENERGY
		and instability >= PrototypeBalance.CUMULUS_INSTABILITY
		and humidity >= PrototypeBalance.CUMULUS_HUMIDITY
	):
		return Stage.CUMULUS_CLOUD
	if (
		energy >= PrototypeBalance.UPDRAFT_ENERGY
		and instability >= PrototypeBalance.UPDRAFT_INSTABILITY
	):
		return Stage.WARM_UPDRAFT
	if instability >= PrototypeBalance.UNSTABLE_AIR_INSTABILITY:
		return Stage.UNSTABLE_AIR
	return Stage.MOISTURE_POCKET


static func get_stage_label(stage: Stage) -> String:
	match stage:
		Stage.MOISTURE_POCKET:
			return "Moisture Pocket"
		Stage.UNSTABLE_AIR:
			return "Unstable Air"
		Stage.WARM_UPDRAFT:
			return "Warm Air Updraft"
		Stage.CUMULUS_CLOUD:
			return "Cumulus Cloud"
		Stage.DEVELOPING_THUNDERSTORM:
			return "Developing Thunderstorm"
		_:
			return "Moisture Pocket"


static func get_next_stage(stage: Stage) -> Stage:
	match stage:
		Stage.MOISTURE_POCKET:
			return Stage.UNSTABLE_AIR
		Stage.UNSTABLE_AIR:
			return Stage.WARM_UPDRAFT
		Stage.WARM_UPDRAFT:
			return Stage.CUMULUS_CLOUD
		Stage.CUMULUS_CLOUD:
			return Stage.DEVELOPING_THUNDERSTORM
		_:
			return Stage.DEVELOPING_THUNDERSTORM


static func get_next_stage_label(stage: Stage) -> String:
	if stage == Stage.DEVELOPING_THUNDERSTORM:
		return "Mature Thunderstorm (future)"
	return get_stage_label(get_next_stage(stage))


static func get_progress_toward_next(
	stage: Stage,
	energy: float,
	instability: float,
	humidity: float
) -> float:
	if stage == Stage.DEVELOPING_THUNDERSTORM:
		return 1.0

	var next: Stage = get_next_stage(stage)
	match next:
		Stage.UNSTABLE_AIR:
			return clampf(
				instability / PrototypeBalance.UNSTABLE_AIR_INSTABILITY,
				0.0,
				1.0
			)
		Stage.WARM_UPDRAFT:
			return minf(
				clampf(energy / PrototypeBalance.UPDRAFT_ENERGY, 0.0, 1.0),
				clampf(instability / PrototypeBalance.UPDRAFT_INSTABILITY, 0.0, 1.0)
			)
		Stage.CUMULUS_CLOUD:
			return minf(
				minf(
					clampf(energy / PrototypeBalance.CUMULUS_ENERGY, 0.0, 1.0),
					clampf(instability / PrototypeBalance.CUMULUS_INSTABILITY, 0.0, 1.0)
				),
				clampf(humidity / PrototypeBalance.CUMULUS_HUMIDITY, 0.0, 1.0)
			)
		Stage.DEVELOPING_THUNDERSTORM:
			return minf(
				minf(
					clampf(energy / PrototypeBalance.THUNDERSTORM_ENERGY, 0.0, 1.0),
					clampf(instability / PrototypeBalance.THUNDERSTORM_INSTABILITY, 0.0, 1.0)
				),
				clampf(humidity / PrototypeBalance.THUNDERSTORM_HUMIDITY, 0.0, 1.0)
			)
		_:
			return 0.0


static func get_visual_preset(stage: Stage) -> Dictionary:
	match stage:
		Stage.MOISTURE_POCKET:
			return {
				"core_color": Color(0.55, 0.78, 0.98, 0.88),
				"halo_color": Color(0.45, 0.72, 0.98, 0.35),
				"scale_mult": 1.0,
				"halo_mult": 1.0,
				"mist_mult": 1.0,
				"show_cumulus_puff": false,
				"show_thunder_glow": false,
			}
		Stage.UNSTABLE_AIR:
			return {
				"core_color": Color(0.62, 0.72, 1.0, 0.9),
				"halo_color": Color(0.5, 0.65, 1.0, 0.42),
				"scale_mult": 1.08,
				"halo_mult": 1.12,
				"mist_mult": 1.15,
				"show_cumulus_puff": false,
				"show_thunder_glow": false,
			}
		Stage.WARM_UPDRAFT:
			return {
				"core_color": Color(0.72, 0.78, 1.0, 0.92),
				"halo_color": Color(0.58, 0.68, 1.0, 0.5),
				"scale_mult": 1.18,
				"halo_mult": 1.28,
				"mist_mult": 1.3,
				"show_cumulus_puff": false,
				"show_thunder_glow": false,
			}
		Stage.CUMULUS_CLOUD:
			return {
				"core_color": Color(0.82, 0.88, 1.0, 0.95),
				"halo_color": Color(0.7, 0.82, 1.0, 0.62),
				"scale_mult": 1.32,
				"halo_mult": 1.45,
				"mist_mult": 1.55,
				"show_cumulus_puff": true,
				"show_thunder_glow": false,
			}
		Stage.DEVELOPING_THUNDERSTORM:
			return {
				"core_color": Color(0.72, 0.78, 0.95, 0.96),
				"halo_color": Color(0.55, 0.62, 0.92, 0.72),
				"scale_mult": 1.48,
				"halo_mult": 1.58,
				"mist_mult": 1.75,
				"show_cumulus_puff": true,
				"show_thunder_glow": true,
			}
		_:
			return get_visual_preset(Stage.MOISTURE_POCKET)
