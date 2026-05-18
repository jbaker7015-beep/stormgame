# Match Day Cycle & End-of-Day Recap

**Related:** [USMapAndZonesDesign.md](USMapAndZonesDesign.md), [DestructionSystem.md](DestructionSystem.md), [StormSimulationVision.md](StormSimulationVision.md), [PlayerProgressionDesign.md](PlayerProgressionDesign.md)

---

## One match = one calendar day

| Rule | Detail |
|------|--------|
| **Start** | **00:00** (midnight) when player confirms spawn |
| **Briefing** | **Unlimited** until player presses **Ready** (no forced timer) |
| **End** | **24:00** (midnight) — day complete |
| **Time display** | HUD clock `HH:MM`; optional “Day 1” label for multi-day modes (future) |

### Time compression (gameplay)

Full real-time 24h is too slow. Use **accelerated sim time**:

| Setting | Example | 24h game day |
|---------|---------|--------------|
| `minutes_per_game_hour` | 2.0 real min | ~48 real minutes |
| Tunable per mode | Ranked vs casual | Design in `DayCycleConfig` |

**Diurnal cycle (optional S1+):**
- CAPE often peaks afternoon; stabilizes night.  
- Briefing uses **peak-risk window** text even if play spans full clock.

---

## Player storm limit

| Stage | Rule |
|-------|------|
| **Launch / early progression** | **One active storm** per player at a time |
| **After death** | **Respawn picker** opens: new random spawn candidates in the **same zone** chosen at briefing; player picks one — still **one active storm**, new cell |
| **Skill tree (later)** | Unlocks may allow **2+ simultaneous** storms, split cells, or faster replan — see [PlayerProgressionDesign.md](PlayerProgressionDesign.md) |

No multi-storm juggling until progression explicitly unlocks it.

---

## Gameplay objective (storm + destruction era)

Within the 24h day, player:

1. Grows storm via **routing** and **ingredients** ([StormSimulationVision.md](StormSimulationVision.md)).  
2. Pursues **maximum destruction** through settlements ([DestructionSystem.md](DestructionSystem.md)).  
3. Competes with **AI storms** for atmosphere and damage score.

Agency defense is **not** in this loop yet.

---

## End-of-day recap

When clock hits **24:00** (or all players eliminated — TBD), simulation stops and **recap screen** shows.

### Primary metric: damage in U.S. dollars ($)

| Column | Content |
|--------|---------|
| Rank | 1…N |
| Storm name / id | Player username or AI label |
| Controller | Player / AI |
| **Total damage ($)** | Sum of settlement + infrastructure loss |
| Breakdown | Wind $ / Hail $ / Flood $ / Lightning $ |
| Peak mode | Supercell, Bow, etc. |
| Zones affected | List of zone IDs traversed |
| Path distance | Optional stat |

**Tie-breakers (config):** highest single-city damage → peak wind gust → earliest time to first $1M.

### Recap presentation

- **CONUS heatmap** of damage density (scar overlay).  
- **Bar chart** per player/AI storm.  
- **Replay highlights** (future): top 3 damage events with timestamp.  
- **XP / currency** awards hook into [PlayerProgressionDesign.md](PlayerProgressionDesign.md) (later).

### AI inclusion

All **AI storms** that dealt damage appear on the same leaderboard — transparent accounting.

---

## Between days (meta, future)

- **Campaign:** chain days with persistent player level.  
- **Map state:** optional carry-over depletion (default: **fresh seed each day** for arcade matches).  
- **Season ladder:** weekly tornado season leaderboards.

---

## Implementation mapping

| Phase | Delivers |
|-------|----------|
| **S9** | Planning → 00:00 start |
| **M6** | `GameClock` 00:00–24:00 + compression |
| **D2–D3** | Dollar damage accumulation |
| **D5** | Recap UI + persistence of recap stats |
| **P1** | XP from recap totals (later) |

---

## Document history

| Date | Note |
|------|------|
| 2026-05 | Midnight–midnight day, dollar recap, one storm default |
| 2026-05 | Death → new spawn pick in original zone (not fixed coordinates) |
