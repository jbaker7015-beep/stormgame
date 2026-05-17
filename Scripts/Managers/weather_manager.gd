extends Node

## Global weather coordinator (Prototype Phase 1 stub).
## Tracks atmospheric zones so future systems can query the world state.

signal zone_registered(zone: Node2D)

var active_zones: Array[Node2D] = []


func register_zone(zone: Node2D) -> void:
	if zone in active_zones:
		return
	active_zones.append(zone)
	zone_registered.emit(zone)


func unregister_zone(zone: Node2D) -> void:
	active_zones.erase(zone)
