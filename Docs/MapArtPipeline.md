# CONUS Map Art Pipeline (2.5D)

**Goal:** Real, readable **United States** briefing + gameplay map with terrain pop, settlements, and interstates — not gray placeholders long-term.

**Phase:** **M2** (parallel once **M1** zone IDs exist)

---

## Visual target

- **2D game map** with **3D-like** depth (not full S12 volumetric yet)
- Stylized realism — readable at strategic zoom like a broadcast map + light height
- **12 climate zones** tinted subtly under terrain
- **Cities / towns** extruded markers; **I-routes** embossed lines

---

## Production pipeline (recommended)

### Step 1 — CONUS base (vector + height)

| Task | Tool options |
|------|----------------|
| Accurate CONUS outline + state borders | Simplified GeoJSON → Blender / Inkscape / Figma |
| Heightmap (dramatized, not 1:1 DEM) | **Natural Earth** / USGS NED simplified → paint in Photoshop or Gaea |
| Zone polygons | Draw atop height in QGIS or Godot editor plugin; export JSON → `climate_zone_config.gd` |

Keep **low poly** — this is a game board, not GIS.

### Step 2 — 2.5D shading in Godot

| Layer | Technique |
|-------|-----------|
| Terrain | `Sprite2D` or `MeshInstance2D` with **normal-mapped** albedo; shader **offsets UV** by height for fake extrusion |
| Relief pop | Directional light in shader; optional **parallax mapping** on briefing camera |
| Water | Gulf / Great Lakes / oceans as flat animated normal map |
| Roads | Vector polyline → texture strip mesh; slight emboss in shader |
| Settlements | Icon atlas by tier; shadow offset scales with “importance” |

**Godot 4:** `CanvasItemMaterial` + custom `shader_type canvas_item` for height tint, or pre-rendered layers from Blender.

### Step 3 — Blender pre-render option (fastest polish)

1. Extrude heightmap mesh of CONUS.  
2. Camera orthographic top-down → render **albedo**, **normal**, **AO** passes.  
3. Import PNGs to `Art/Map/CONUS/`; parallax only on briefing scene.

Good for **M2 milestone** before in-engine shader work.

### Step 4 — Settlements & roads (data-driven)

- `settlements.json` — `{name, tier, pos, zone_id}`  
- `roads.json` — `{id, points[], type: "interstate"}`  
- Tool: script to place from simplified OpenStreetMap (filter `highway=motorway`) — **do not** ship OSM raw; simplify.

### Step 5 — Briefing vs play

| Scene | Detail level |
|-------|----------------|
| `briefing_conus.tscn` | Full 2.5D, overlays, zone badges |
| `gameplay_world.tscn` | Same tiles; can reduce parallax for FPS |

---

## File layout (target)

```text
Art/Map/CONUS/
  conus_albedo.png
  conus_normal.png
  conus_height.png
  zone_mask_12.png          # optional ID map
Data/Map/
  climate_zone_polygons.json
  settlements.json
  interstates.json
Scenes/Map/
  briefing_conus.tscn
  gameplay_world.tscn
Shaders/
  map_terrain_25d.gdshader
```

---

## Milestones

| Milestone | Deliverable |
|-----------|-------------|
| M2a | Static CONUS albedo + zone outlines (playable ugly) |
| M2b | Normal/height shader pop |
| M2c | Settlements + interstate art pass |
| M2d | Briefing camera parallax + zoom to zone |

---

## What we use until M2 ships

Prototype uses `biome_map_overlay.gd` + `atmosphere_overlay_draw.gd` on the expanded rect — **same zone IDs** as final CONUS.

---

## Document history

| Date | Note |
|------|------|
| 2026-05 | Pipeline for real CONUS 2.5D art |
