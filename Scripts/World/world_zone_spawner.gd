extends Node2D

## Instantiates atmospheric zones from WorldMapConfig layout.

const ZONE_SCENE: PackedScene = preload("res://Scenes/World/atmospheric_zone.tscn")


func _ready() -> void:
	for entry in WorldMapConfig.BIOME_LAYOUT:
		var zone: AtmosphericZone = ZONE_SCENE.instantiate() as AtmosphericZone
		zone.biome = entry["biome"]
		zone.position = entry["pos"]
		zone.name = String(entry["name"]).replace(" ", "")
		add_child(zone)
