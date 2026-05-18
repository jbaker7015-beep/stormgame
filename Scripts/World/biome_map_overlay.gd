extends Node2D

## Stylized readable map labels for the expanded prototype region.

var _region_fill: Array[Dictionary] = [
	{
		"points": PackedVector2Array([60, 160, 520, 120, 580, 620, 120, 680]),
		"color": Color(0.12, 0.38, 0.72, 0.14),
	},
	{
		"points": PackedVector2Array([1980, 140, 2440, 120, 2500, 520, 2020, 560]),
		"color": Color(0.1, 0.36, 0.68, 0.12),
	},
	{
		"points": PackedVector2Array([480, 120, 1320, 80, 1380, 420, 520, 460]),
		"color": Color(0.28, 0.52, 0.32, 0.12),
	},
	{
		"points": PackedVector2Array([1180, 880, 2100, 860, 2160, 1280, 1120, 1300]),
		"color": Color(0.42, 0.58, 0.28, 0.1),
	},
	{
		"points": PackedVector2Array([720, 680, 1680, 640, 1740, 1080, 680, 1120]),
		"color": Color(0.55, 0.42, 0.22, 0.1),
	},
	{
		"points": PackedVector2Array([320, 960, 980, 920, 1040, 1320, 280, 1340]),
		"color": Color(0.92, 0.72, 0.28, 0.08),
	},
]

const REGION_LABELS: Array[Dictionary] = [
	{"text": "Gulf Coast", "pos": Vector2(280, 420)},
	{"text": "Atlantic Shelf", "pos": Vector2(2140, 360)},
	{"text": "Northern Forest Belt", "pos": Vector2(720, 260)},
	{"text": "Metro Heat Corridor", "pos": Vector2(1240, 760)},
	{"text": "Sunbelt Plains", "pos": Vector2(1880, 300)},
	{"text": "Southern Prairie", "pos": Vector2(520, 1080)},
	{"text": "River Valley", "pos": Vector2(1760, 540)},
	{"text": "StormGame — Expanded Region", "pos": Vector2(860, 52)},
]


func _ready() -> void:
	z_index = -2
	queue_redraw()


func _draw() -> void:
	var font: Font = ThemeDB.fallback_font
	var font_size: int = 15
	var bounds: Rect2 = WorldMapConfig.PLAY_RECT

	for region in _region_fill:
		draw_colored_polygon(region["points"], region["color"])

	for label_data in REGION_LABELS:
		var text: String = label_data["text"]
		var pos: Vector2 = label_data["pos"]
		var size: int = 20 if text.contains("StormGame") else font_size
		var color: Color = Color(1, 1, 1, 0.88) if text.contains("StormGame") else Color(0.9, 0.95, 1, 0.55)
		draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)

	for entry in WorldMapConfig.BIOME_LAYOUT:
		var marker_pos: Vector2 = entry["pos"]
		draw_string(
			font,
			marker_pos + Vector2(-36, -48),
			entry["name"],
			HORIZONTAL_ALIGNMENT_CENTER,
			96,
			13,
			Color(1, 1, 1, 0.72)
		)

	draw_rect(bounds, Color(1, 1, 1, 0.22), false, 2.0)
