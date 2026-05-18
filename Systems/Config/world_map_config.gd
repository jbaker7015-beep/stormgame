extends Node

## Single source of truth for expanded prototype map layout.

const MAP_WIDTH: float = 2560.0
const MAP_HEIGHT: float = 1440.0
const PLAY_RECT: Rect2 = Rect2(48.0, 88.0, 2464.0, 1264.0)
const SPAWN_CENTER: Vector2 = Vector2(1280.0, 720.0)

# Camera limits (slightly inset from play rect).
const CAMERA_LIMIT_LEFT: int = 56
const CAMERA_LIMIT_TOP: int = 96
const CAMERA_LIMIT_RIGHT: int = 2504
const CAMERA_LIMIT_BOTTOM: int = 1344

# Expanded biome layout for the larger region.
const BIOME_LAYOUT: Array[Dictionary] = [
	{"name": "Ocean", "pos": Vector2(300.0, 480.0), "biome": 0},
	{"name": "Ocean Shelf", "pos": Vector2(2180.0, 420.0), "biome": 0},
	{"name": "Lake", "pos": Vector2(880.0, 1020.0), "biome": 1},
	{"name": "Highland Lake", "pos": Vector2(1180.0, 340.0), "biome": 1},
	{"name": "River", "pos": Vector2(1780.0, 560.0), "biome": 2},
	{"name": "Metro Heat", "pos": Vector2(1240.0, 780.0), "biome": 3},
	{"name": "Sunbelt Plains", "pos": Vector2(1960.0, 280.0), "biome": 4},
	{"name": "Prairie", "pos": Vector2(520.0, 1120.0), "biome": 4},
	{"name": "Forest", "pos": Vector2(580.0, 300.0), "biome": 5},
	{"name": "Coastal Forest", "pos": Vector2(1580.0, 980.0), "biome": 5},
]

const AI_SPAWN_POSITIONS: Array[Vector2] = [
	Vector2(760.0, 620.0),
	Vector2(1820.0, 380.0),
	Vector2(1420.0, 1040.0),
]
