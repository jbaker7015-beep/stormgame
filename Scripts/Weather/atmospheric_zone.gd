class_name AtmosphericZone
extends Area2D

## Biome-based atmospheric region. Stacks contributions when overlapping multiple zones.

const ZoneData = preload("res://Systems/Data/atmospheric_zone_data.gd")

@export var biome: ZoneData.Biome = ZoneData.Biome.OCEAN
@export var zone_radius: float = -1.0

@onready var _shape: CollisionShape2D = $CollisionShape2D
@onready var _fill: Polygon2D = $Fill
@onready var _aura: CPUParticles2D = $AuraParticles
var _preset: Dictionary = {}
var _humidity_rate: float = 0.0
var _heat_rate: float = 0.0
var _instability_rate: float = 0.0
var _display_name: String = ""


func _ready() -> void:
	_load_preset()
	_setup_shape()
	_apply_zone_theme()
	WeatherManager.register_zone(self)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _exit_tree() -> void:
	WeatherManager.unregister_zone(self)


func _load_preset() -> void:
	_preset = ZoneData.get_preset(biome)
	_display_name = _preset.get("display_name", "Zone")
	_humidity_rate = _preset.get("humidity_rate", 0.0)
	_heat_rate = _preset.get("heat_rate", 0.0)
	_instability_rate = _preset.get("instability_rate", 0.0)

	if zone_radius <= 0.0:
		zone_radius = _preset.get("default_radius", 120.0)


func _setup_shape() -> void:
	var circle := CircleShape2D.new()
	circle.radius = zone_radius
	_shape.shape = circle

	var points: PackedVector2Array = PackedVector2Array()
	var segments := 32
	for i in segments:
		var angle := TAU * float(i) / float(segments)
		points.append(Vector2(cos(angle), sin(angle)) * zone_radius)
	_fill.polygon = points


func _apply_zone_theme() -> void:
	_fill.color = _preset.get("fill_color", Color(0.4, 0.6, 0.9, 0.25))
	_aura.color = _preset.get("aura_color", Color(1.0, 1.0, 1.0, 0.4))


func _on_body_entered(body: Node2D) -> void:
	var stats: Node = _get_stats_from_body(body)
	if stats == null:
		return
	stats.add_zone_contribution(_humidity_rate, _heat_rate, _instability_rate, _display_name)


func _on_body_exited(body: Node2D) -> void:
	var stats: Node = _get_stats_from_body(body)
	if stats == null:
		return
	stats.remove_zone_contribution(_humidity_rate, _heat_rate, _instability_rate, _display_name)


func _get_stats_from_body(body: Node2D) -> Node:
	if body.has_node("Stats"):
		return body.get_node_or_null("Stats")
	return null
