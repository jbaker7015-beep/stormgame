class_name AtmosphericZoneData
extends Resource

## Data-driven presets for atmospheric zones (Prototype Phase 2).
## Keeps biome tuning out of scene logic so new zones stay easy to add.

enum Biome { OCEAN, LAKE, RIVER, CITY, PLAINS, FOREST }


static func get_preset(biome: Biome) -> Dictionary:
	match biome:
		Biome.OCEAN:
			return {
				"display_name": "Ocean",
				"humidity_rate": 26.0,
				"heat_rate": 4.0,
				"instability_rate": 2.5,
				"fill_color": Color(0.12, 0.42, 0.82, 0.28),
				"aura_color": Color(0.35, 0.72, 1.0, 0.55),
				"default_radius": 150.0,
			}
		Biome.LAKE:
			return {
				"display_name": "Lake",
				"humidity_rate": 20.0,
				"heat_rate": 2.0,
				"instability_rate": 1.0,
				"fill_color": Color(0.18, 0.5, 0.78, 0.26),
				"aura_color": Color(0.4, 0.75, 0.95, 0.45),
				"default_radius": 120.0,
			}
		Biome.RIVER:
			return {
				"display_name": "River",
				"humidity_rate": 16.0,
				"heat_rate": 1.0,
				"instability_rate": 0.5,
				"fill_color": Color(0.2, 0.55, 0.7, 0.24),
				"aura_color": Color(0.45, 0.8, 0.9, 0.4),
				"default_radius": 90.0,
			}
		Biome.CITY:
			return {
				"display_name": "Urban Heat",
				"humidity_rate": 4.0,
				"heat_rate": 24.0,
				"instability_rate": 5.0,
				"fill_color": Color(0.85, 0.38, 0.22, 0.26),
				"aura_color": Color(1.0, 0.55, 0.28, 0.5),
				"default_radius": 115.0,
			}
		Biome.PLAINS:
			return {
				"display_name": "Sunlit Plains",
				"humidity_rate": 6.0,
				"heat_rate": 20.0,
				"instability_rate": 3.0,
				"fill_color": Color(0.92, 0.72, 0.28, 0.22),
				"aura_color": Color(1.0, 0.85, 0.4, 0.45),
				"default_radius": 125.0,
			}
		Biome.FOREST:
			return {
				"display_name": "Forest",
				"humidity_rate": 14.0,
				"heat_rate": 6.0,
				"instability_rate": 4.0,
				"fill_color": Color(0.22, 0.58, 0.32, 0.26),
				"aura_color": Color(0.45, 0.9, 0.55, 0.4),
				"default_radius": 110.0,
			}
		_:
			return get_preset(Biome.OCEAN)
