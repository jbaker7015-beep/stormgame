extends Node

## Twelve U.S. climate zones (historical regions). See Docs/ClimateZones.md.
## Polygons are on prototype play space until CONUS art (M2) replaces shapes.

enum Season { SPRING, SUMMER, FALL, WINTER }

const ZONE_COUNT: int = 12

static var _zones: Array = []
awddstatic var _base: Array = []
static var _initialized: bool = false


static func _ensure_initialized() -> void:
	if _initialized:
		return
	_initialized = true
	_zones = _build_zones()
	_base = _build_base()


static func _build_zones() -> Array:
	return [
		{
			"id": 0,
			"code": "Z01",
			"name": "Pacific Northwest",
			"points": PackedVector2Array([80, 80, 520, 60, 560, 380, 100, 420]),
		},
		{
			"id": 1,
			"code": "Z02",
			"name": "California Coast",
			"points": PackedVector2Array([60, 400, 480, 380, 500, 720, 80, 760]),
		},
		{
			"id": 2,
			"code": "Z03",
			"name": "Desert Southwest",
			"points": PackedVector2Array([480, 520, 900, 500, 920, 900, 460, 920]),
		},
		{
			"id": 3,
			"code": "Z04",
			"name": "Southern Plains",
			"points": PackedVector2Array([900, 560, 1380, 540, 1400, 960, 880, 980]),
		},
		{
			"id": 4,
			"code": "Z05",
			"name": "Central Plains",
			"points": PackedVector2Array([880, 200, 1420, 180, 1440, 540, 860, 560]),
		},
		{
			"id": 5,
			"code": "Z06",
			"name": "Gulf Coast",
			"points": PackedVector2Array([1380, 720, 1900, 700, 1920, 1100, 1360, 1120]),
		},
		{
			"id": 6,
			"code": "Z07",
			"name": "Southeast",
			"points": PackedVector2Array([1680, 380, 2200, 360, 2220, 700, 1660, 720]),
		},
		{
			"id": 7,
			"code": "Z08",
			"name": "Florida Peninsula",
			"points": PackedVector2Array([2100, 820, 2480, 800, 2500, 1180, 2080, 1200]),
		},
		{
			"id": 8,
			"code": "Z09",
			"name": "Great Lakes",
			"points": PackedVector2Array([1180, 60, 1680, 40, 1700, 360, 1160, 380]),
		},
		{
			"id": 9,
			"code": "Z10",
			"name": "Northeast",
			"points": PackedVector2Array([1680, 40, 2380, 20, 2400, 340, 1700, 360]),
		},
		{
			"id": 10,
			"code": "Z11",
			"name": "Rocky Mountains",
			"points": PackedVector2Array([520, 180, 880, 160, 900, 520, 500, 540]),
		},
		{
			"id": 11,
			"code": "Z12",
			"name": "Ohio & Tennessee Valley",
			"points": PackedVector2Array([1420, 360, 1680, 340, 1700, 700, 1400, 720]),
		},
	]


static func _build_base() -> Array:
	return [
		{"cape": 800.0, "cin": -40.0, "dewpoint_f": 52.0, "temp_f": 68.0, "pw_mm": 28.0, "shear_ms": 12.0, "srh": 60.0, "steering": Vector2(8, 2)},
		{"cape": 1200.0, "cin": -20.0, "dewpoint_f": 55.0, "temp_f": 78.0, "pw_mm": 18.0, "shear_ms": 10.0, "srh": 50.0, "steering": Vector2(6, 0)},
		{"cape": 2200.0, "cin": -80.0, "dewpoint_f": 58.0, "temp_f": 102.0, "pw_mm": 32.0, "shear_ms": 14.0, "srh": 90.0, "steering": Vector2(5, -2)},
		{"cape": 3200.0, "cin": -30.0, "dewpoint_f": 68.0, "temp_f": 88.0, "pw_mm": 42.0, "shear_ms": 18.0, "srh": 140.0, "steering": Vector2(12, 0)},
		{"cape": 3500.0, "cin": -25.0, "dewpoint_f": 66.0, "temp_f": 86.0, "pw_mm": 38.0, "shear_ms": 20.0, "srh": 180.0, "steering": Vector2(14, 2)},
		{"cape": 2800.0, "cin": -15.0, "dewpoint_f": 74.0, "temp_f": 90.0, "pw_mm": 55.0, "shear_ms": 12.0, "srh": 80.0, "steering": Vector2(8, 3)},
		{"cape": 2400.0, "cin": -20.0, "dewpoint_f": 72.0, "temp_f": 92.0, "pw_mm": 48.0, "shear_ms": 11.0, "srh": 100.0, "steering": Vector2(6, 2)},
		{"cape": 2600.0, "cin": -10.0, "dewpoint_f": 76.0, "temp_f": 91.0, "pw_mm": 58.0, "shear_ms": 9.0, "srh": 70.0, "steering": Vector2(4, 4)},
		{"cape": 1600.0, "cin": -35.0, "dewpoint_f": 62.0, "temp_f": 80.0, "pw_mm": 35.0, "shear_ms": 16.0, "srh": 120.0, "steering": Vector2(10, 1)},
		{"cape": 1400.0, "cin": -45.0, "dewpoint_f": 60.0, "temp_f": 78.0, "pw_mm": 32.0, "shear_ms": 14.0, "srh": 90.0, "steering": Vector2(8, 0)},
		{"cape": 1800.0, "cin": -50.0, "dewpoint_f": 50.0, "temp_f": 82.0, "pw_mm": 22.0, "shear_ms": 17.0, "srh": 110.0, "steering": Vector2(11, -1)},
		{"cape": 2000.0, "cin": -30.0, "dewpoint_f": 65.0, "temp_f": 84.0, "pw_mm": 40.0, "shear_ms": 15.0, "srh": 130.0, "steering": Vector2(9, 1)},
	]


static func get_zones() -> Array:
	_ensure_initialized()
	return _zones


static func get_zone_metadata(zone_id: int) -> Dictionary:
	_ensure_initialized()
	if zone_id < 0 or zone_id >= _zones.size():
		return {}
	return _zones[zone_id]


static func get_zone_id_at(world_pos: Vector2) -> int:
	_ensure_initialized()
	for zone in _zones:
		if Geometry2D.is_point_in_polygon(world_pos, zone["points"]):
			return zone["id"]
	return -1


static func _season_multipliers(season: Season) -> Dictionary:
	match season:
		Season.SPRING:
			return {"cape": 1.15, "dewpoint_f": 1.02, "shear_ms": 1.12, "srh": 1.1}
		Season.SUMMER:
			return {"cape": 1.2, "dewpoint_f": 1.08, "shear_ms": 0.95, "srh": 0.9}
		Season.FALL:
			return {"cape": 1.05, "dewpoint_f": 1.0, "shear_ms": 1.08, "srh": 1.05}
		Season.WINTER:
			return {"cape": 0.55, "dewpoint_f": 0.92, "shear_ms": 1.0, "srh": 0.85}
		_:
			return {"cape": 1.2, "dewpoint_f": 1.08, "shear_ms": 0.95, "srh": 0.9}


static func get_baselines(zone_id: int, season: Season) -> Dictionary:
	_ensure_initialized()
	if zone_id < 0 or zone_id >= _base.size():
		zone_id = 4
	var b: Dictionary = _base[zone_id].duplicate()
	var mul: Dictionary = _season_multipliers(season)
	b["cape"] = b["cape"] * mul.get("cape", 1.0)
	b["dewpoint_f"] = b["dewpoint_f"] * mul.get("dewpoint_f", 1.0)
	b["shear_ms"] = b["shear_ms"] * mul.get("shear_ms", 1.0)
	b["srh"] = b["srh"] * mul.get("srh", 1.0)
	b["lcl_m"] = maxf(400.0, 2200.0 - b["dewpoint_f"] * 18.0)
	return b


static func season_name(season: Season) -> String:
	match season:
		Season.SPRING:
			return "Spring"
		Season.SUMMER:
			return "Summer"
		Season.FALL:
			return "Fall"
		Season.WINTER:
			return "Winter"
		_:
			return "Summer"
