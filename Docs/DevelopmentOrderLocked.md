# Development Order (Locked)

**Repo:** `stormgame/` root (`project.godot`) — **not** `storm-game/`.  
**Platform:** PC (keyboard/mouse).  
**Mode first:** Solo + AI fill; multiplayer after storm loop is fun.

---

## Your decisions (recorded)

| Topic | Choice |
|-------|--------|
| Day length | ~48 real minutes default (`2 min` / game hour) — tunable |
| Cross-zone travel | **Yes** — full CONUS crossable in one day |
| Multiplayer | **Later**; solo + AI first |
| Briefing timer | **Unlimited until Ready** |
| Damage $ | **Realistic** scale (millions → billions) |
| Map art | **Real 2.5D CONUS** — see [MapArtPipeline.md](MapArtPipeline.md) |
| Audio | **Recorded high-quality** — see [AudioPipeline.md](AudioPipeline.md) |
| Ecosystem density | **No empty zones** — AI fills to targets ([EcosystemPopulation.md](EcosystemPopulation.md)) |
| Zones | **12 climate zones** from historical patterns — [ClimateZones.md](ClimateZones.md) |
| Recap | **All storms** — every player + AI row |
| Skill tree | **Deferred** ([PlayerProgressionDesign.md](PlayerProgressionDesign.md)) — not blocking dev |

---

## Recommended build order (from current prototype)

```text
NOW ─────────────────────────────────────────────────────────────►

Block A — Prove sim on expanded playfield (current 2560×1440 → CONUS layout)
  S1  Atmosphere grid + overlay cuts (CAPE, Td, shear, …)
  S2  Trajectory movement (retire WASD)
  S3  Depletion, organization, death, zone respawn picker

Block B — Real U.S. map & day loop
  M1  12 climate zone polygons + season tables (ClimateZones.md)
  M2  CONUS 2.5D map art (MapArtPipeline.md) — parallel art track
  M3  Outlook text + overlay UI tabs
  M4  Zone zoom + confirm zone
  M5  Random spawns + respawn picker in zone
  M6  Game clock 00:00–24:00
  S9  Briefing → Ready → play integration

Block C — Storm depth
  S4→S5  Modes + storm interaction
  S6     Lightning v2
  S7     Recorded audio (AudioPipeline.md)
  S8     Free cam + hover stats
  S8b    Tactical radar — bottom-right minimap + M zone map, 10-min nowcast loop
  S10    Cell visuals
  S11    AI v2 (trajectory + ecosystem fill)

Block D — Destruction
  D1→D5  Settlements, $ damage, recap (all storms listed)

Block E — Presentation & scale
  S12    3D presentation option
  MP1+   Multiplayer + M7 occupancy (when solo loop ships)

Block F — Later
  P1+    Levels / skill tree
  Agency After D slice
```

**Why S1 before M2 art:** Gameplay reads **fields** from the grid; art is a visual skin on the same zone IDs. M2 can swap in while S2–S3 continue.

---

## Current milestone

**In progress:** **S1** + **M1** foundation (grid + 12 zone config on prototype coordinates).

**UX note:** [BriefingVsGameplay.md](BriefingVsGameplay.md) — U.S. map + ingredient tabs = **briefing scene**; current playtest = legacy gameplay + optional S1 dev keys 1–4.
