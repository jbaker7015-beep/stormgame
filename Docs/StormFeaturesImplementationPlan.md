# Storm Features — Implementation Plan

**Prerequisite reading:** [StormSimulationVision.md](StormSimulationVision.md)  
**Real meteorology (terms, units, sources):** [StormMeteorologyReference.md](StormMeteorologyReference.md)  
**Out of scope until storm slice is done:** Weather Service / agency ([WeatherAgencyDesign.md](WeatherAgencyDesign.md) — do not implement).  
**Prototype code:** Current WASD + abstract bars remain **legacy** until Phase S2 retires them.

---

## Guiding Rules

1. **No agency code** until **storm slice (S)** and **destruction slice (D)** are met.  
2. **Data-driven** atmosphere fields (resources on disk, not hardcoded zones only).  
3. **One playable milestone per phase** — always shippable in Godot.  
4. **2D sim first**, **3D presentation later** — same rules, new renderer.  
5. Update [DevelopmentRoadmap.md](DevelopmentRoadmap.md) when a phase ships.

---

## Phase Overview

| Phase | Name | Delivers |
|-------|------|----------|
| **S0** | Design lock | Docs aligned (this file + vision) |
| **S1** | Atmosphere grid | CAPE, dewpoint, temp, shear fields + overlays |
| **S2** | Trajectory movement | Click-drag path, slow motion, wind steering |
| **S3** | Depletion & death | Ingredient consumption, wrong-air decay, respawn |
| **S4** | Storm modes | Supercell, squall line, bow, hook, hail core |
| **S5** | Storm interaction | Merge, line build, outflow competition |
| **S6** | Lightning v2 | IC forks + CG strikes + timed thunder |
| **S7** | Recorded audio | Wind, rain, hail, thunder sample pipeline |
| **S8** | Camera & inspection | Free cam, snap-back, hover stats |
| **S8b** | Tactical radar | Bottom-right minimap + **M** zone map; 10‑min nowcast loop; all storms |
| **M1–M5** | CONUS map & briefing | 10 zones, seasons, 2.5D map, overlays, zone zoom, spawns |
| **M6** | Game day clock | 00:00–24:00, time compression |
| **M7** | Briefing zone occupancy | Per-zone Storm/Agency 👤 vs 🤖 counts (multiplayer) |
| **MP1** | Multiplayer lobby & briefing sync | Shared briefing timer, zone commits |
| **S9** | Day planning integration | Wires M1–M6 + planning state |
| **S10** | Cell visuals v1 | Radar/map storm art (2D credible cells) |
| **S11** | AI v2 | Trajectory AI, same rules as player |
| **S12** | 3D presentation | Volumetric clouds, sky lightning (mechanics unchanged) |
| **D1** | Settlements on map | Mini towns + cities as destructible map features |
| **D2** | Route-driven damage | Wind / hail / flood / lightning damage along storm path |
| **D3** | Destruction feedback | Building damage states, debris, readable impact |
| **D4** | Destruction scoring | Match goals, route planning rewards, AI targets towns |
| **D5** | End-of-day recap | Damage $ leaderboard, CONUS heatmap, AI + player rows |
| **—** | **Deferred (after D)** | Weather Service, agency defense |
| **P1+** | Player progression | Levels, skill tree, multi-storm unlock — [PlayerProgressionDesign.md](PlayerProgressionDesign.md) |

**Order:** **M1–M6** (map/briefing/day) interleave with **S1–S12** → Destruction **D1–D5** → **P1+** progression → Agency (far future).

**Map/briefing spec:** [USMapAndZonesDesign.md](USMapAndZonesDesign.md) · **Day/recap:** [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md)

---

## S0 — Design Lock (docs only)

**Goal:** Team agrees storm-first scope; arcade controls marked legacy.

**Tasks:**

- [x] [StormSimulationVision.md](StormSimulationVision.md)  
- [x] This implementation plan  
- [x] Update [GameDesign.md](GameDesign.md) philosophy (semi-realistic > arcade)  
- [x] Update [DevelopmentRoadmap.md](DevelopmentRoadmap.md)  
- [x] Update [ControlsDesign.md](ControlsDesign.md), [AudioDesign.md](AudioDesign.md), [ArtDirection.md](ArtDirection.md)  
- [x] Add banner to [WeatherAgencyDesign.md](WeatherAgencyDesign.md): deferred  

**Exit:** No code required; design reviews complete.

---

## S1 — Atmosphere Grid

**Goal:** Map stores **operational-style** meteorological fields ([StormMeteorologyReference.md](StormMeteorologyReference.md)).

**Implement:**

1. `AtmosphereField` resource per cell/chunk — **minimum fields:**  
   `cape`, `cin`, `surface_dewpoint`, `surface_temperature`, `precipitable_water`, `bulk_shear_0_6km`, `srh_0_1km`, `steering_wind` (vector), `lcl_height`, `recovery_rate`.  
2. **Lift** layer: boundary polylines or mask for cold front, warm front, **dryline**, **outflow boundary**, orographic zones.  
3. **Four-ingredients** debug panel: pass/fail per region (moisture + instability + lift + shear).  
4. **Daily seed** → synoptic pattern (e.g. dryline + high CAPE warm sector).  
5. **Terrain modifiers:** orographic lift, urban heat, water **Td**/PW flux.  
6. UI overlays use **real abbreviations** (CAPE, CIN, Td, SRH) with tooltips from reference doc.  
7. Bridge: legacy biome zones **bias** fields until grid is complete.

**Design thresholds:** Use reference doc tiers (e.g. supercell shear ~15–20 m/s 0–6 km) as tunable `PrototypeBalance` entries, scaled by [StormDifficultyDesign.md](StormDifficultyDesign.md) (`Easy` = lower bars + richer map; `Extreme` = stricter + merge requirements).

**Files (expected):**

- `Systems/Data/atmosphere_field_config.gd`  
- `Scripts/World/atmosphere_grid.gd`  
- `Scripts/UI/atmosphere_overlay_ui.gd`  

**Exit:** Player sees CAPE/dewpoint/temp/shear on map before storm spawns.

**Depends:** S0  

---

## M1 — CONUS & 10 Climate Zones

**Goal:** United States play space with **10 weather zones** and **seasons**.

**Spec:** [USMapAndZonesDesign.md](USMapAndZonesDesign.md)

**Implement:**

1. `USZoneConfig` × 10: polygon, `climate_baseline` per season, settlement density.  
2. CONUS `play_bounds` replacing prototype rectangle (migrate `WorldMapConfig`).  
3. `Season` enum + `DaySeedGenerator`: `season + date + difficulty → atmosphere`.  
4. Zone enter/exit events for storm (climate switch).  

**Exit:** Storm crossing from Z04 → Z05 applies different field biases.

**Depends:** S0 — parallel with S1  

---

## M2 — Briefing Map (2.5D)

**Goal:** 2D map with **3D-like** terrain, cities, towns, major roads.

**Implement:**

1. CONUS terrain height tint + normal shading / extrusion shader.  
2. Settlement markers (hamlet / town / city) — visible at briefing zoom.  
3. Interstate polylines (major roads only).  
4. Parallax sky / subtle cloud layer.  

**Exit:** Briefing screen shows recognizable U.S. with popping terrain and settlements.

**Depends:** M1  

---

## M3 — Outlook & Overlay Cuts

**Goal:** General weather outlook + clickable **ingredient** layers.

**Implement:**

1. `OutlookGenerator` — CONUS summary text from seed.  
2. Overlay tabs: CAPE, CIN, Td, Temp, PW, Shear, SRH, Lift, Severe composite.  
3. Tooltips → [StormPlayerCheatSheet.md](StormPlayerCheatSheet.md).  
4. Threshold colors from [StormMeteorologyReference.md](StormMeteorologyReference.md) × difficulty.  

**Exit:** Player cycles cuts on CONUS briefing before zone pick.

**Depends:** S1, M2  

---

## M4 — Zone Zoom & Zone Outlook

**Goal:** Click zone → zoom → localized forecast.

**Implement:**

1. Zone click hit-test on 10 polygons.  
2. Camera tween to zone bounds.  
3. `ZoneOutlook` text + overlays clipped to zone.  
4. Back button → CONUS view.  

**Exit:** Zone 05 shows “Moderate supercell risk along dryline” with local CAPE map.

**Depends:** M1, M3  

---

## M5 — Random Spawn Points

**Goal:** Weighted spawn candidates in chosen zone.

**Implement:**

1. `SpawnGenerator`: N points (5–8) inside zone polygon.  
2. Weight by local CAPE, Td, lift proximity, distance to settlements (tunable).  
3. UI: markers + mini stat on hover; player selects one.  
4. Store `spawn_zone_id` (locked for match) + `initial_spawn_position`.  
5. On death: call `SpawnGenerator` again **same zone only** → respawn picker UI.

**Exit:** Death offers fresh spawn set in original zone; cannot respawn in a different zone.

**Depends:** M4, S1  

---

## M6 — Game Day Clock

**Goal:** Midnight to midnight match with compression.

**Spec:** [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md)

**Implement:**

1. `GameClock`: 00:00–24:00, `minutes_per_game_hour` config.  
2. HUD clock; optional diurnal CAPE modifier.  
3. End at 24:00 → trigger recap (D5).  
4. Enforce **one active storm** per player (`StormOwnership`).  

**Exit:** Match ends at midnight; duration ~45–60 real minutes at default compression.

**Depends:** M5 — wire in S9  

---

## M7 — Briefing Zone Occupancy (multiplayer)

**Goal:** During briefing, show **live** human vs AI counts per zone for **Storm** and **Agency**.

**Spec:** [BriefingZoneOccupancy.md](BriefingZoneOccupancy.md)

**Implement:**

1. Server `ZoneOccupancyTracker` — `storm_human`, `storm_ai`, `agency_human`, `agency_ai` per `zone_id`.  
2. RPC: `commit_zone(zone_id, faction, is_human)`; change zone before spawn.  
3. CONUS badges + zone zoom **Occupancy** panel.  
4. Solo: show 🤖 only (or hide 👤 row). Agency columns `0` until agency phase.  
5. AI lobby fill assigns 🤖 counts to zones at briefing start.

**Exit:** Two humans in lobby see each other’s zone picks update before spawn.

**Depends:** M4 — parallel **MP1** for lobby  

---

## S2 — Trajectory Movement

**Goal:** Replace WASD as primary control.

**Implement:**

1. Input: click-drag → polyline path (max length / max nodes configurable).  
2. `StormMotionController`: target speed 20–50 km/h equivalent; **acceleration** and **turn penalty**.  
3. **Steering flow** sample from grid wind at storm position.  
4. Final velocity = `lerp(planned_direction, environmental_velocity, env_weight)` + cold-pool vector (stub 0 until S4).  
5. Disable or gate `PrototypeBalance.MOVE_SPEED` WASD behind debug flag.  
6. HUD: planned path ghost line, current drift indicator.

**Exit:** Moving feels **heavy**; storm cannot instantly reverse; path replan on cooldown works.

**Depends:** S1  

---

## S3 — Depletion, Organization & Death

**Goal:** Routing matters; storms die and respawn.

**Implement:**

1. Footprint ingestion: reduce local CAPE/moisture per timestep.  
2. **Organization** stat (0–100): rises in favorable air, falls in dry/hostile air.  
3. Death when organization ≤ 0 for sustained period.  
4. **Respawn flow:** on death → regenerate candidates in `spawn_zone_id` → player picks (M5 UI); not locked to first coordinates.  
5. Remove passive `ENERGY_SYNTHESIS_RATE` dominance; growth from **ingestion** primarily.  
6. Tune time constants (growth 3–5× slower than current prototype).

**Exit:** Deliberately bad route kills storm; respawn works; depleted zones visible on overlay.

**Depends:** S2  

---

## S4 — Storm Modes & Structures

**Goal:** Emergent modes matching [StormMeteorologyReference.md](StormMeteorologyReference.md) §5–7.

**Implement:**

1. `StormMode` enum: `PULSE`, `MULTICELL`, `SUPERCELL`, `QLCS`/`LINE`, `BOW`, `DERECHO` (rare), `MCS_BALANCED`, `MCS_COLD_POOL_DOMINANT`.  
2. Transitions gated on **CAPE + Td + bulk_shear + SRH + lift** (four ingredients), plus parallel motion for lines.  
3. **Mesocyclone** (persistent rotating updraft) → hook echo flag; with **SRH** → tornado gate.  
4. **Hail:** updraft + CAPE + time in core + **wet-bulb zero** tier (or VIL proxy).  
5. **Cold pool** / **gust front** vector → propagation (S2).  
6. Radar layer: **reflectivity (dBZ)**, hook, bow.  
7. Remap legacy evolution stages → visual tier inside mode.

**Migration note:** Current stages 1–6 become **visual tiers** inside modes, not the sole progression axis.

**Exit:** Player can intentionally pursue supercell vs line; hook/bow/hail telegraphed on UI.

**Depends:** S3  

---

## S5 — Storm Interaction

**Goal:** Multi-storm ecology on one map.

**Implement:**

1. Interaction volumes: inflow, outflow, updraft core radii.  
2. Merge rules (see vision doc table).  
3. Shared **squall line** entity when ≥2 cells align; cold-pool dominant vs balanced stats.  
4. AI uses same depletion rules (prep for S11).  
5. Combined stat panel when merged.

**Exit:** Player + AI can form a line or kill each other via outflow; map depletion is shared.

**Depends:** S4  

---

## S6 — Lightning v2

**Goal:** IC forks + occasional CG + proper thunder delay.

**Implement:**

1. `LightningDirector`: spawn branching polylines in cloud volume (L-system or recursive branches).  
2. Separate **CG** channel: pick ground strike point under core, rate-limited.  
3. Link to charge stat (updraft + ice phase proxy).  
4. Thunder: `delay = distance / 343 m/s` scaled to map units.  
5. Keep procedural fallback flag off in release builds.

**Exit:** Sky fills with branches; ground strikes rare but memorable; thunder lags correctly.

**Depends:** S4 (charge stat)  

---

## S7 — Recorded Audio

**Goal:** Real storm soundscape.

**Implement:**

1. Asset pipeline: `.ogg` loops + one-shots (wind light/heavy, rain, hail, thunder near/far).  
2. **License log** file in repo.  
3. `StormAudioManager` layers by intensity; **per-storm** and **ambient** buses.  
4. CG triggers thunder one-shot; IC triggers softer crackle.  
5. Remove dependency on procedural synth except `DEBUG_PROCEDURAL_AUDIO`.

**Exit:** Playtesters identify rain/wind/hail/thunder without seeing UI.

**Depends:** S6 for CG sync (can start rain/wind earlier in parallel)

---

## S8 — Camera & Inspection

**Goal:** Chaser-style observation.

**Implement:**

1. Detach camera: edge pan or middle-mouse drag; zoom limits from `WorldMapConfig`.  
2. Snap-back key (e.g. `Space` or `Home`).  
3. Hover pick storm collider → tooltip panel (stats from S4/S3).  
4. Optional: minimap click to pan.

**Exit:** Player watches AI bow echo across map, snaps back to own cell.

**Depends:** S3 (stats exist)  

---

## S8b — Tactical Radar (TV minimap + zone map)

**Goal:** Broadcast-style **bottom-right radar** + **`M`** expanded zone map with **10-minute nowcast loop** if storms stay on course.

**Spec:** [StormTacticalRadar.md](StormTacticalRadar.md)

**Implement:**

1. `NowcastSimulator` — extrapolate 10 game-min steps from path + steering + mode.  
2. `TacticalRadarMinimap` — bottom-right; reflectivity + all storm icons; loop animation.  
3. `TacticalRadarExpanded` — full zone on **M**; same loop; hover storm stats.  
4. Register all storms (player + AI) in `StormRegistry` autoload or `GameManager`.  
5. Recompute loop on path commit / replan.  
6. Input action `toggle_tactical_map` → **M**.

**Exit:** Player watches loop, hits **M**, sees whole zone and every storm’s forecast track.

**Depends:** **S2** (path), **S1** (reflectivity proxy); parallel **S8**

---

## S9 — Day Planning Integration

**Goal:** Full **briefing → zone → spawn → midnight start** pipeline.

**Spec:** [USMapAndZonesDesign.md](USMapAndZonesDesign.md), [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md)

**Implement:**

1. `GameManager` state machine: `LOBBY → BRIEFING_CONUS → BRIEFING_ZONE → SPAWN_PICK → PLAYING → RECAP`.  
2. Integrate **M2–M6** + S1 overlays.  
3. Optional planning timer (ranked).  
4. On confirm spawn → **00:00** + single player storm spawn.  
5. No agency faction.

**Exit:** Full loop from CONUS outlook to gameplay start documented in UX.

**Depends:** M3, M4, M5, M6, S3  

---

## S10 — Cell Visuals v1 (2D)

**Goal:** Storms read as cells, not circles.

**Implement:**

1. Art pass: updraft core, anvil sprite, rain shield, flanking cells.  
2. Mode-specific silhouettes (supercell vs bow).  
3. Hail core and hook overlay on radar layer.  
4. Motion-linked tilt (lean downshear).

**Exit:** Screenshots look like weather radar + structure, not io-game blobs.

**Depends:** S4  

---

## S11 — AI v2

**Goal:** AI plays by same meteorology rules.

**Implement:**

1. Replace seek-zone-only logic with **path planner** toward high CAPE/moisture respecting shear.  
2. AI replans on depletion and outflow threats.  
3. Difficulty = forecast reading quality + reaction time, not cheat speed.

**Exit:** AI forms lines and supercells believably; competes for same ingredients.

**Depends:** S2–S5  

---

## S12 — 3D Presentation (long pole)

**Goal:** Semi-realistic look without rewriting sim.

**Implement:**

1. Parallel scene: `Node3D` map, heightmap or low-poly terrain.  
2. Volumetric or stacked billboard **cloud volume** driven by same storm stats.  
3. Lightning in world space; rain particles with wind.  
4. Camera: chase + orbit; snap-back preserved.  
5. 2D sim grid can drive 3D visuals via adapter.

**Exit:** Same day, same rules; presentation matches vision reel.

**Depends:** S10 mechanics stable  

---

## D1 — Settlements on Map

**Goal:** The map has **mini towns** and **cities** storm players route toward to destroy.

**Implement:**

1. `Settlement` data: type (`HAMLET`, `TOWN`, `CITY`), population tier, footprint polygon, resistance profile.  
2. Place settlements on `prototype_world` / grid — not every tile; clusters along rivers, plains, coasts.  
3. Map legend + minimap icons; hover shows name, population, damage state.  
4. Settlements do **not** block storm motion; they are **targets**, not walls.  
5. Larger cities = more structures + higher score + slightly higher heat/island (optional S1 field bump).

**Exit:** Player can see towns/cities on map before damage exists.

**Depends:** S12 recommended (readable map); can start in 2D after **S4** if needed for layout testing.

---

## D2 — Route-Driven Damage

**Goal:** **Storm path and mode** cause destruction — not a separate “attack button.”

**Implement:**

1. Damage tick when storm footprint overlaps settlement:  
   - **Wind** — line/bow mode, gust front, tornado tier  
   - **Hail** — hail core swath  
   - **Flood** — slow-moving heavy rain / training cells  
   - **Lightning** — CG strikes in footprint (fires/outages lite)  
2. Gate damage by storm **organization** and **mode** (pulse storm barely scratches; supercell bow is severe).  
3. Structural resistance per building class (residential < commercial < core infrastructure).  
4. **Routing gameplay:** player plans path through **high-value** or **vulnerable** corridors; wrong mode = weak damage.

**Exit:** Deliberately routing a bow echo through a town causes major damage; skimming with a weak pulse does not.

**Depends:** S4 modes, D1 settlements

---

## D3 — Destruction Feedback

**Goal:** Destruction feels earned and readable.

**Implement:**

1. Building damage states (intact → damaged → destroyed) — simple sprite/state, not full physics sim.  
2. Debris particles (limited count); optional tornado debris lofting.  
3. Local audio from D7 library: hail on roofs, wind howl, collapse one-shots.  
4. Persistent scar on map for the **day** (damaged zone overlay).

**Exit:** Player sees and hears a town take a hit as the storm passes.

**Depends:** D2; S7 audio helps

---

## D4 — Destruction Scoring & Objectives

**Goal:** Give storm players a reason to **plan routes for destruction**.

**Implement:**

1. Match objectives (examples): damage % of region, hit N cities, maximize hail swath through farmland/town.  
2. Score breakdown on end screen: wind vs hail vs flood vs lightning contribution.  
3. AI storms **seek damage** when competitive (same rules, no cheats).  
4. Optional: daily briefing marks **high-risk population centers** (forecast flavor, not agency UI).

**Exit:** A full run is “grow the right storm → steer through towns → score”; bad route = weak storm + low damage.

**Depends:** D2, D3; S11 AI

---

## D5 — End-of-Day Recap ($)

**Goal:** Midnight recap with **damage dollars** per player and AI storm.

**Spec:** [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md)

**Implement:**

1. `DamageLedger`: per-storm running $ totals + wind/hail/flood/lightning split.  
2. Recap UI: ranked table, CONUS damage heatmap, peak mode.  
3. Hook for **P1** XP (stub values OK).  
4. Return to lobby / next day.

**Exit:** Screen shows “$2.4B — PlayerName — Supercell — Z04,Z05”.

**Depends:** D2, M6  

---

## P1+ — Player Progression (deferred)

**Goal:** Levels, skill tree, optional **multi-storm** unlock.

**Spec:** [PlayerProgressionDesign.md](PlayerProgressionDesign.md) — **after D5**.

| Phase | Delivers |
|-------|----------|
| P1 | XP from recap $ |
| P2 | Skill tree branch 1 |
| P3 | Multi-storm capstone + full tree |

---

## Deferred (After Destruction Slice)

| Item | Former roadmap | When |
|------|----------------|------|
| Weather Service / agency | Phase 7 | **After D1–D4** — agencies defend what storms destroy |
| Dual-faction planning timer | Multiplayer design | With agency |
| Multiplayer sync | Phase 9 | After storm + destruction solo slice |
| Cosmetics | Phase 10 | Late |
| Progression P1+ | This plan | After D5 |

---

## Suggested Implementation Order (Critical Path)

**Map & day (parallel with storms):**
```
M1 + S1 (parallel) → M2 → M3 → M4 → M5 → M6
```

**Storms:**
```
S0 → S1 → S2 → S3 → S8 + S8b → S4 → S5 → S6 → S7 → S9 (needs M5,M6) → S10 → S11 → S12
```

**Destruction:**
```
D1 (can layout during M2) → D2 → D3 → D4 → D5
```

**Progression:** `P1+` after D5

**Then:** Agency / multiplayer (separate docs).

**Parallelizable:** S7 audio assets during S4–S6. D1 settlement layout can be drafted on map during S10.

---

## Technical Notes (Godot 4)

- Keep **simulation** in autoloads / plain scripts (`AtmosphereGrid`, `StormMotionController`) — scenes stay thin.  
- Use **chunked grid** (e.g. 64×64 cells) for 2560×1440 play space.  
- **Deterministic daily seed** for replay and tests.  
- All tuning in `Systems/Config/` resources, not magic numbers in draw code.  
- Known gotcha: do not share one `AudioStream` across players; prefer `.ogg` import for loops.

---

## Testing Checklist (Per Phase)

| Phase | Test |
|-------|------|
| S1 | Overlays match seed; terrain bumps CAPE |
| S2 | Cannot exceed max speed; path + wind blend visible |
| S3 | Depletion persists; death → zone respawn picker |
| S4 | Supercell only with shear+moisture; bow after line speed threshold |
| S5 | Two AI merge to line; player undercut by outflow |
| S6 | IC frequent, CG rare; thunder delay feels right |
| S7 | No procedural buzz; hail audible in core |
| S8 | Snap-back from far pan |
| S9 | Bad spawn → quick death; good spawn → sustained cell |
| S10 | Hook visible on supercell screenshot |
| S11 | AI dies in dry air like player |

---

## Document History

| Date | Note |
|------|------|
| 2026-05 | Storm-first phased plan; agency deferred |
| 2026-05 | D1–D4 destruction after S12, before agency; route-target towns/cities |
| 2026-05 | M1–M6 CONUS/10 zones/briefing; D5 $ recap; P1+ progression deferred |
| 2026-05 | M7/MP1 briefing zone occupancy — Storm + Agency human vs AI |
