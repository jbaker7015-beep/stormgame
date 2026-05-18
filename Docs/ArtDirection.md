# Art Direction

**Authoritative storm targets:** [StormSimulationVision.md](StormSimulationVision.md)  
**Implementation order:** [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md) (S10, S12)

---

## Vision

Semi-realistic **convective storm cells** on a **satellite / radar** readable map — not arcade blobs (Twister.io-style circles).

Players should recognize:

- Updraft tower and anvil
- Rain shield and stratiform region
- Hail core (high reflectivity)
- Hook echo (rotation)
- Bow echo (severe line segment)
- Squall line vs isolated supercell silhouette

---

## Presentation Path

| Stage | Look |
|-------|------|
| **Prototype (current)** | Polygons, debug zones — acceptable for mechanics only |
| **S10 — 2D cell art** | Radar reflectivity + structure sprites, motion tilt |
| **S12 — 3D** | Terrain + volumetric or layered clouds; lightning in sky volume |

**3D was always the goal** for immersion; **mechanics stay 2D/grid-backed** until the storm slice is proven, then visuals migrate without rewriting rules.

---

## Readability Rules

1. **Gameplay clarity** over photorealism — every structure has a UI or radar tell.  
2. **Mode silhouette** beats particle spam — players identify supercell vs bow at a glance.  
3. **Effects support structure** — rain shaft, dust outflow, hail swath, not generic sparkles.  
4. **Scale** — storm footprint grows with mode; camera zoom bands per stage (see Controls/Camera in vision doc).

---

## Reference Tone

- Weather radar products (reflectivity, velocity where useful)
- Storm-chaser documentary framing (wide map + dramatic sky in 3D phase)
- Avoid: neon io-game aesthetics, instant size pops, cartoon lightning only

---

## Out of Scope (Art)

- Weather Service UI, sirens, broadcast overlays — deferred with agency gameplay

## Destruction Art (D phases — after S12)

- Mini town and city **map icons** + zoomed district sprites
- Damage states (intact / damaged / destroyed)
- Hail swath, wind debris, flood tint on settlements
- See [DestructionSystem.md](DestructionSystem.md)
