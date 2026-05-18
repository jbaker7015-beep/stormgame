# Storm Tactical Radar (Minimap + Zone Map)

**Player-facing name:** **Radar** or **Tactical map** (broadcast-style, like TV severe-weather coverage).  
**Related:** [UIUXDesign.md](UIUXDesign.md), [ControlsDesign.md](ControlsDesign.md), [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md) — **S8b**

---

## Purpose

Give players a **familiar TV weather-map** read while routing a storm:

- See **where you are** on the radar picture  
- Watch a **short loop** of the **next ~10 minutes** if the storm **stays on the current course**  
- Decide to **keep going** or **replan** the path  
- See **all human and AI storms** on the same map  

This is **nowcast** (minutes ahead), not the pre-day CONUS briefing ([USMapAndZonesDesign.md](USMapAndZonesDesign.md)).

---

## Two UI modes

| Mode | Position | Trigger | Content |
|------|----------|---------|---------|
| **Minimap radar** | **Bottom-right** HUD corner | Always on during play (toggleable in settings) | Zone crop, radar reflectivity, storm icons, 10‑min loop |
| **Expanded zone radar** | Full-screen or large panel overlay | **`M`** key (toggle) | Whole **current zone** (or follow zone), same loop + all storms + legend |

**`M` again** or **Esc** closes expanded view; minimap returns.

---

## Visual style (TV broadcast)

- **Reflectivity palette** — green → yellow → red (configurable colorblind mode)  
- Soft **range rings** or county lines (optional, subtle)  
- **Your storm** — distinct icon + planned path ghost  
- **Other storms** — 👤 player / 🤖 AI (or unified icon + color by owner)  
- **Loop badge:** `NOWCAST 10 MIN` in corner  
- Slight **VHS/radar sweep** optional polish (S10+ art)

Not the same as ingredient briefing overlays (CAPE/Td) — this is **precip / storm motion** focused.

---

## 10-minute nowcast loop

### What it shows

If the player **does not change course**, the system extrapolates:

1. **Player storm** — along committed **path polyline** + **steering wind** + **cold-pool propagation** (same rules as S2 motion).  
2. **Reflectivity footprint** — moves with storm mode (higher dBZ in core, stratiform trail downshear).  
3. **AI / other player storms** — each uses **its own** current path + motion rules.  
4. **Time horizon:** **10 game minutes** (configurable), sampled every **1 game minute** → **10 frames** looped ~2–3 real seconds per cycle (tunable).

### What it does *not* claim

- Not a full numerical weather model.  
- Does not predict **your** replan before you draw it — recomputes when path changes.  
- Ingredient fields (CAPE) can change from depletion; loop uses **current** field snapshot + motion (v2 may refresh each frame).

### Player use

| See on loop | Action |
|-------------|--------|
| Core heading into **high reflectivity / towns** | Stay course for damage (D phase) |
| Track into **dry air** or off ingredients | Replan before organization drops |
| **AI bow** merging ahead | Merge or dodge |
| Multiple storms **colliding** | Adjust for interaction (S5) |

---

## Minimap (bottom-right)

| Element | Behavior |
|---------|----------|
| Size | ~18–22% of screen width; aspect ~4:3 |
| Scope | **Current zone** bounds, or **window around player** (config: zone vs local 200 km) |
| Layers | Radar reflectivity (nowcast frame) + storm dots + your path |
| Loop | Auto-plays 10‑min forecast cycle |
| Click | Optional: click minimap to open **M** expanded view centered on click |

Opacity: ~90% so gameplay world still visible behind HUD chrome.

---

## Expanded map (`M`)

| Element | Behavior |
|---------|----------|
| Coverage | Full **spawn zone** polygon at minimum; toggle **adjacent zones** faint (future) |
| Storms | **All** player + AI storms with labels on hover |
| Forecast | Same 10‑min loop, larger; timeline scrub optional (v2) |
| Path edit | **Optional S8b+:** draw new path from expanded map (same as world click-drag) |
| Ingredients | Toggle small inset: CAPE or shear (secondary to radar) |

Does **not** replace free camera (S8) — complements it.

---

## Multiplayer

- Minimap shows **every** storm entity in scope.  
- **No** exact human names on minimap (fairness); full name on hover in expanded view only (config).  
- Occupancy briefing ([BriefingZoneOccupancy.md](BriefingZoneOccupancy.md)) is pre-day; this is **in-day** tracking.

---

## Agency (deferred)

When Weather Service ships, agency players get the **same radar** with extra layers (warnings, population). Radar code is **shared component**.

---

## Implementation — S8b

| Task | Notes |
|------|--------|
| `NowcastSimulator` | 10 step extrapolation from `StormMotionController` |
| `TacticalRadarMinimap` | Control bottom-right; samples `AtmosphereGrid` + storm list |
| `TacticalRadarExpanded` | Full UI; bound to `M` |
| Reflectivity render | Reuse atmosphere / mode dBZ proxy |
| Storm registry | `GameManager` / `AIManager` list all storm nodes |

**Depends:** **S2** (path + motion), **S1** (field sample), storm list from existing AI spawner.

**Order:** After **S2**, alongside or right after **S8** camera.

---

## Controls summary

| Key | Action |
|-----|--------|
| **M** | Toggle expanded zone tactical radar |
| **Esc** | Close expanded (if open) |
| **Tab** (optional) | Pause loop on current frame |

See [ControlsDesign.md](ControlsDesign.md).

---

## Success criteria

- [ ] Bottom-right minimap visible in play.  
- [ ] Loop shows ~10 min of **on-course** motion for player storm.  
- [ ] All AI storms visible and moving on loop.  
- [ ] **M** opens zone-scale map with same data.  
- [ ] Replanning path updates loop within 1 s.  

---

## Document history

| Date | Note |
|------|------|
| 2026-05 | TV-style tactical radar minimap + M expand; 10-min nowcast loop |
