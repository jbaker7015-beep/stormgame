# Development Roadmap

# Development Philosophy

StormGame should be built iteratively.

The goal is to:
- create small playable milestones
- avoid feature overload
- test systems early
- prioritize **credible storm simulation** over arcade feel

Multiplayer and **Weather Service / agency** should NOT be the focus until the **storm vertical slice** is complete.

**Storm-era plan (authoritative):** [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md)  
**Vision:** [StormSimulationVision.md](StormSimulationVision.md)  
**Meteorology terms (NOAA/NWS/SPC):** [StormMeteorologyReference.md](StormMeteorologyReference.md)  
**Player cheat sheet / difficulty:** [StormPlayerCheatSheet.md](StormPlayerCheatSheet.md), [StormDifficultyDesign.md](StormDifficultyDesign.md)  
**U.S. map / day / recap:** [USMapAndZonesDesign.md](USMapAndZonesDesign.md), [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md), [PlayerProgressionDesign.md](PlayerProgressionDesign.md)  
**Multiplayer briefing occupancy:** [BriefingZoneOccupancy.md](BriefingZoneOccupancy.md), [MultiplayerDesign.md](MultiplayerDesign.md)  
**Tactical radar (in-day):** [StormTacticalRadar.md](StormTacticalRadar.md)

---

# Legacy Phases (Prototype — largely complete)

These phases built the **arcade prototype** (WASD, abstract bars, polygon visuals):

| Phase | Status | Notes |
|-------|--------|-------|
| 1 Foundation | Done | Movement, HUD, collection |
| 2 Atmospheric sim | Partial | Biome zones; grid CAPE in S1 |
| 3 Evolution | Done | Stages 1–6; will merge into **modes** (S4) |
| 4 Visual FX | Done | Rain/wind/lightning draw; S6 upgrades lightning |
| 5 AI | Done | Will become S11 trajectory AI |

---

# Storm Simulation Phases (current focus)

Execute in order — details in [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md).

| Phase | Goal |
|-------|------|
| **S0** | Design lock (docs) |
| **S1** | Atmosphere grid (CAPE, dewpoint, temp, shear) |
| **S2** | Trajectory movement (click-drag path, slow steering) |
| **S3** | Depletion, organization, death, respawn |
| **S4** | Storm modes (supercell, line, bow, hook, hail core) |
| **S5** | Storm–storm interaction & merge |
| **S6** | Lightning v2 (IC forks + CG + thunder delay) |
| **S7** | Recorded audio (wind, rain, hail, thunder) |
| **S8** | Free camera + snap-back + hover stats |
| **M1–M6** | CONUS map, 10 zones, seasons, 2.5D briefing, zone zoom, spawns, 24h clock |
| **M7** | Briefing zone occupancy (Storm + Agency, human vs AI) |
| **MP1** | Multiplayer lobby + shared briefing sync |
| **S9** | Briefing → spawn → day start integration |
| **S10** | 2D credible cell / radar visuals |
| **S11** | AI v2 (same rules as player) |
| **S12** | 3D presentation (clouds, sky, terrain) |

**Success condition for storm slice:** Player plans route on a forecast map, grows a recognizable supercell or squall line, hears real storm audio, dies from bad routing, and observes other storms with hover stats.

---

# Destruction Phases (after storm slice, before agency)

Execute **D1–D4** after **S12** (or when S4+ modes are stable for testing). Details: [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md).

| Phase | Goal |
|-------|------|
| **D1** | Mini towns + cities on map |
| **D2** | Damage from storm route & mode (wind/hail/flood/lightning) |
| **D3** | Visual/audio destruction feedback |
| **D4** | Scoring, objectives, AI targets settlements |
| **D5** | End-of-day recap — damage $ per storm |
| **P1+** | Levels & skill tree (after D5) |

**Player fantasy:** grow the right storm → **steer through towns** → destroy.

See [DestructionSystem.md](DestructionSystem.md).

---

# Deferred Phases (after destruction slice)

## Weather Agency Systems (was Phase 7) — **FAR OUT**

- Forecasting, warnings, evacuations, infrastructure defense  
- Dual-side planning timer with Weather Service  
- See [WeatherAgencyDesign.md](WeatherAgencyDesign.md) — **do not implement** until **storm (S) + destruction (D)** slices sign off

## Storm Specialization (was Phase 8)

- Tornado / hurricane / blizzard / lightning paths — **fold into S4 modes** first; full branches later

## Multiplayer (was Phase 9)

- After single-player storm slice is fun and stable

## Polish (was Phase 10)

- Progression, cosmetics, balance, extra maps — late

---

# Phase 1–10 Original Text (reference)

<details>
<summary>Original roadmap entries (archived)</summary>

## Phase 1 - Foundation
Controllable atmospheric entity, movement, HUD.

## Phase 2 - Atmospheric Simulation
Humidity/heat zones, environmental interactions.

## Phase 3 - Evolution System
Moisture pocket through thunderstorm stages.

## Phase 4 - Visual Effects
Particles, rain, wind, lightning, audio.

## Phase 5 - AI Systems
AI storms, competition.

## Phase 6 - Destruction Systems
Building damage, debris — **deferred**.

## Phase 7 - Weather Agency Systems
**Deferred** — storms first.

## Phase 8 - Storm Specialization
Branching paths — **partially absorbed by S4**.

## Phase 9 - Multiplayer
**Deferred**.

## Phase 10 - Polish
**Deferred** until storm + destruction priorities met.

</details>
