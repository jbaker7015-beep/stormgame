# UI/UX Design

**In-game help (planned):** [StormPlayerCheatSheet.md](StormPlayerCheatSheet.md) from Help / briefing screen.  
**Difficulty UI:** badge + optional live ingredient checklist per [StormDifficultyDesign.md](StormDifficultyDesign.md).  
**Briefing UX:** [USMapAndZonesDesign.md](USMapAndZonesDesign.md) — CONUS 2.5D → overlay tabs → zone zoom → spawn pick.  
**Multiplayer briefing:** [BriefingZoneOccupancy.md](BriefingZoneOccupancy.md) — per-zone Storm/Agency 👤 vs 🤖 badges, live updates.  
**Recap UX:** [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md) — $ damage table + heatmap at 24:00.  
**In-game tactical radar:** [StormTacticalRadar.md](StormTacticalRadar.md) — bottom-right minimap + **M** expand.

# Philosophy

UI should:
- remain clean
- minimize clutter
- communicate weather clearly
- support high readability

The game should feel like a mix of:
- weather radar systems
- modern strategy games
- atmospheric simulations

---

# HUD Design

## Storm HUD

Displays:
- humidity
- heat
- instability
- evolution progress
- storm category
- warnings

---

## Agency HUD

Displays:
- radar
- forecasts
- civilian risk
- warning systems
- emergency resources

---

# Radar Design

## Tactical radar (in-day) — primary

See [StormTacticalRadar.md](StormTacticalRadar.md).

- **Bottom-right minimap** — TV-style reflectivity, loops **next 10 minutes** on current course  
- **`M`** — expand to **full zone** radar; all player + AI storms  
- Used to **replan** or stay on path  

## Briefing radar (pre-day)

CONUS / zone overlays (CAPE, Td, shear) — [USMapAndZonesDesign.md](USMapAndZonesDesign.md).

Radar should:
- feel dynamic
- display precipitation
- show storm rotation
- communicate danger levels

---

# Evolution UI

Players should clearly understand:
- current stage
- next evolution requirements
- specialization options

---

# Warning UI

Weather alerts should:
- feel urgent
- use color-coded severity
- remain readable during chaos

---

# Accessibility Goals

- readable fonts
- colorblind-friendly options
- scalable UI
- controller support

---

# Long-Term UI Goals

The interface should feel:
- immersive
- atmospheric
- professional
- disaster-management inspired