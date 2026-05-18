extends Node2D

## Stylized readable map labels for the prototype region (polish pass).

var _region_fill: Array[Dictionary] = [
	{
		"points": PackedVector2Array([40, 120, 380, 100, 420, 420, 80, 450]),
		"color": Color(0.12, 0.38, 0.72, 0.14),
	},
	{
		"points": PackedVector2Array([360, 80, 720, 60, 760, 280, 400, 300]),
		"color": Color(0.28, 0.52, 0.32, 0.12),
	},
	{
		"points": PackedVector2Array([680, 300, 1180, 280, 1220, 520, 700, 540]),
		"color": Color(0.42, 0.58, 0.28, 0.1),
	},
	{
		"points": PackedVector2Array([520, 440, 980, 420, 1020, 680, 500, 700]),
		"color": Color(0.55, 0.42, 0.22, 0.1),
	},
]

const REGION_LABELS: Array[Dictionary] = [
	{"text": "Gulf Coast", "pos": Vector2(200, 280)},
	{"text": "Great Lakes", "pos": Vector2(520, 200)},
	{"text": "Atlantic Forest", "pos": Vector2(420, 160)},
	{"text": "Metro Heat Corridor", "pos": Vector2(700, 470)},
	{"text": "Sunbelt Plains", "pos": Vector2(860, 200)},
	{"text": "River Valley", "pos": Vector2(980, 380)},
	{"text": "StormGame Prototype Region", "pos": Vector2(420, 48)},
]

const BIOME_MARKERS: Array[Dictionary] = [
	{"text": "Ocean", "pos": Vector2(220, 320)},
	{"text": "Lake", "pos": Vector2(520, 520)},
	{"text": "Forest", "pos": Vector2(420, 200)},
	{"text": "City", "pos": Vector2(700, 480)},
	{"text": "Plains", "pos": Vector2(860, 180)},
	{"text": "River", "pos": Vector2(980, 380)},
]


func _ready() -> void:
	z_index = -2
	queue_redraw()


func _draw() -> void:
	var font: Font = ThemeDB.fallback_font
	var font_size: int = 15

	for region in _region_fill:
		draw_colored_polygon(region["points"], region["color"])

	for label_data in REGION_LABELS:
		var text: String = label_data["text"]
		var pos: Vector2 = label_data["pos"]
		var size: int = 18 if text.contains("StormGame") else font_size
		var color: Color = Color(1, 1, 1, 0.85) if text.contains("StormGame") else Color(0.9, 0.95, 1, 0.55)
		draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)

	for marker in BIOME_MARKERS:
		draw_string(
			font,
			marker["pos"] + Vector2(-28, -42),
			marker["text"],
			HORIZONTAL_ALIGNMENT_CENTER,
			80,
			13,
			Color(1, 1, 1, 0.7)
		)

	# Subtle border framing the play area.
	var bounds := Rect2(24, 72, 1232, 616)
	draw_rect(bounds, Color(1, 1, 1, 0.2), false, 2.0)
