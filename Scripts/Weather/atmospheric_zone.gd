class_name AtmosphericZone
extends Area2D

## Placeable humidity or heat region. Overlapping moisture pockets collect resources.

enum ZoneType { HUMIDITY, HEAT }

@export var zone_type: ZoneType = ZoneType.HUMIDITY
@export var zone_radius: float = 120.0

@onready var _shape: CollisionShape2D = $CollisionShape2D
@onready var _fill: Polygon2D = $Fill
@onready var _aura: CPUParticles2D = $AuraParticles


func _ready() -> void:
	_setup_shape()
	_apply_zone_theme()
	WeatherManager.register_zone(self)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _exit_tree() -> void:
	WeatherManager.unregister_zone(self)


func _setup_shape() -> void:
	var circle := CircleShape2D.new()
	circle.radius = zone_radius
	_shape.shape = circle

	# Visual disc approximating the collision area.
	var points: PackedVector2Array = PackedVector2Array()
	var segments := 32
	for i in segments:
		var angle := TAU * float(i) / float(segments)
		points.append(Vector2(cos(angle), sin(angle)) * zone_radius)
	_fill.polygon = points


func _apply_zone_theme() -> void:
	match zone_type:
		ZoneType.HUMIDITY:
			_fill.color = Color(0.25, 0.55, 0.95, 0.22)
			_aura.color = Color(0.4, 0.7, 1.0, 0.5)
		ZoneType.HEAT:
			_fill.color = Color(0.95, 0.45, 0.2, 0.22)
			_aura.color = Color(1.0, 0.6, 0.25, 0.5)


func _on_body_entered(body: Node2D) -> void:
	var stats: Node = _get_stats_from_body(body)
	if stats == null:
		return
	match zone_type:
		ZoneType.HUMIDITY:
			stats.set_in_humidity_zone(true)
		ZoneType.HEAT:
			stats.set_in_heat_zone(true)


func _on_body_exited(body: Node2D) -> void:
	var stats: Node = _get_stats_from_body(body)
	if stats == null:
		return
	match zone_type:
		ZoneType.HUMIDITY:
			stats.set_in_humidity_zone(false)
		ZoneType.HEAT:
			stats.set_in_heat_zone(false)


func _get_stats_from_body(body: Node2D) -> Node:
	if body.has_node("Stats"):
		return body.get_node_or_null("Stats")
	return null
