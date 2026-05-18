extends Node2D

## S1 DEV ONLY — atmosphere grid visualization. Final overlays live in briefing scene (S9).
## Keys: 1=CAPE 2=Td 3=Shear 4=SRH 0=off (default off during gameplay).

enum OverlayMode { OFF, CAPE, DEWPOINT, SHEAR, SRH }

var mode: OverlayMode = OverlayMode.OFF

const ClimateConfig = preload("res://Systems/Config/climate_zone_config.gd")

const _CAPE_MAX: float = 4000.0
const _TD_MAX: float = 80.0
const _SHEAR_MAX: float = 25.0
const _SRH_MAX: float = 250.0


func _ready() -> void:
	z_index = -1
	queue_redraw()
	if GameManager:
		GameManager.day_seed_changed.connect(func(_s): queue_redraw())


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		pass


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	match event.keycode:
		KEY_1:
			mode = OverlayMode.CAPE
			queue_redraw()
		KEY_2:
			mode = OverlayMode.DEWPOINT
			queue_redraw()
		KEY_3:
			mode = OverlayMode.SHEAR
			queue_redraw()
		KEY_4:
			mode = OverlayMode.SRH
			queue_redraw()
		KEY_0:
			mode = OverlayMode.OFF
			queue_redraw()
		KEY_R:
			if AtmosphereGrid:
				GameManager.roll_new_day()
				AtmosphereGrid.regenerate()
				queue_redraw()


func _draw() -> void:
	if mode == OverlayMode.OFF or AtmosphereGrid == null:
		return
	_draw_zone_outlines()
	var rect: Rect2 = AtmosphereGrid.get_play_rect()
	var grid_size: Vector2i = AtmosphereGrid.get_grid_size()
	var cell: int = AtmosphereGrid.get_cell_size()
	var origin: Vector2 = rect.position
	for row in grid_size.y:
		for col in grid_size.x:
			var center := origin + Vector2(
				(float(col) + 0.5) * float(cell),
				(float(row) + 0.5) * float(cell)
			)
			var sample: Dictionary = AtmosphereGrid.sample_at_world(center)
			var t: float = _value_for_mode(sample)
			var color: Color = _heat_color(t)
			var half := Vector2(float(cell) * 0.5, float(cell) * 0.5)
			draw_rect(Rect2(center - half, Vector2(cell, cell)), color, true)

	_draw_legend()


func _value_for_mode(sample: Dictionary) -> float:
	match mode:
		OverlayMode.CAPE:
			return clampf(sample.get("cape", 0.0) / _CAPE_MAX, 0.0, 1.0)
		OverlayMode.DEWPOINT:
			return clampf(sample.get("dewpoint_f", 0.0) / _TD_MAX, 0.0, 1.0)
		OverlayMode.SHEAR:
			return clampf(sample.get("bulk_shear_0_6km_ms", 0.0) / _SHEAR_MAX, 0.0, 1.0)
		OverlayMode.SRH:
			return clampf(sample.get("srh_0_1km", 0.0) / _SRH_MAX, 0.0, 1.0)
		_:
			return 0.0


func _heat_color(t: float) -> Color:
	# Blue → green → yellow → red
	var c1 := Color(0.12, 0.2, 0.55, 0.45)
	var c2 := Color(0.2, 0.65, 0.35, 0.5)
	var c3 := Color(0.95, 0.85, 0.2, 0.55)
	var c4 := Color(0.9, 0.15, 0.1, 0.58)
	if t < 0.33:
		return c1.lerp(c2, t / 0.33)
	if t < 0.66:
		return c2.lerp(c3, (t - 0.33) / 0.33)
	return c3.lerp(c4, (t - 0.66) / 0.34)


func _draw_zone_outlines() -> void:
	var font: Font = ThemeDB.fallback_font
	for zone in ClimateConfig.get_zones():
		var pts: PackedVector2Array = zone["points"]
		draw_colored_polygon(pts, Color(1, 1, 1, 0.04))
		draw_polyline(pts, Color(1, 1, 1, 0.22), true, 1.5)
		var center := _polygon_centroid(pts)
		draw_string(font, center + Vector2(-40, -6), zone["code"], HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color(1, 1, 1, 0.35))


func _polygon_centroid(points: PackedVector2Array) -> Vector2:
	if points.is_empty():
		return Vector2.ZERO
	var sum := Vector2.ZERO
	for p in points:
		sum += p
	return sum / float(points.size())


func _draw_legend() -> void:
	var labels: PackedStringArray = PackedStringArray(["CAPE", "Td°F", "Shear m/s", "SRH"])
	var label: String = labels[mode]
	var font: Font = ThemeDB.fallback_font
	draw_string(
		font,
		Vector2(64, 120),
		"[Dev] Overlay: %s  |  1 CAPE  2 Td  3 Shear  4 SRH  0 off  R new day" % label,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		14,
		Color(1, 1, 1, 0.9)
	)
	if GameManager:
		draw_string(
			font,
			Vector2(64, 140),
			"%s  seed %d" % [ClimateConfig.season_name(GameManager.season), GameManager.day_seed],
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			13,
			Color(0.85, 0.92, 1, 0.75)
		)
