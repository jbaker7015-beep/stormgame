# Match Rules

# Philosophy

A **match** is one **calendar day** on the **continental U.S. map** — from **midnight to midnight** — with storms competing for ingredients and **destruction dollars**.

**Not** round-based arena combat. The ecosystem evolves over simulated time.

**Map & briefing:** [USMapAndZonesDesign.md](USMapAndZonesDesign.md)  
**Clock & recap:** [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md)  
**Progression (later):** [PlayerProgressionDesign.md](PlayerProgressionDesign.md)

---

# Match setup

1. **Lobby:** difficulty, season, date seed, roles (storm / agency), AI fill.  
2. **CONUS briefing:** general weather outlook + ingredient overlay tabs + **zone occupancy** (multiplayer).  
3. **Zone pick:** click zone → zoom → see **Storm 👤/🤖** and **Agency 👤/🤖** counts → **confirm zone**.  
4. **Spawn pick:** **random spawn candidates** in zone → player chooses one.  
5. **00:00** — day begins; **one active storm** per player (default).

**Multiplayer occupancy:** [BriefingZoneOccupancy.md](BriefingZoneOccupancy.md) — live per-zone counts during briefing only.

---

# Match phases (within the day)

| Clock window | Phase | What happens |
|--------------|-------|----------------|
| 00:00–06:00 | **Overnight / morning** | Often weaker CAPE; fog/stratus zones; planning payoff for spawn |
| 06:00–14:00 | **Diurnal heating** | CAPE builds; boundaries activate |
| 14:00–20:00 | **Peak severe window** | Best supercell / line potential (zone-dependent) |
| 20:00–24:00 | **Evening decay** | Storms weaken without fuel; last damage pushes |

Exact curves from `DayCycleConfig` + zone + season.

---

# Player rules

| Rule | Detail |
|------|--------|
| **Storms** | **1 active storm** per player at start; multi-storm via skill tree later |
| **Death** | **Respawn picker** in **original zone** (new random candidates); clock keeps running |
| **Movement** | Planned path + environmental steering (not WASD) |
| **Travel** | May leave spawn zone; other zones’ climates apply |
| **Goal** | Grow severe modes + **max destruction $** before 24:00 |

---

# Victory & scoring

**Primary (storm era):** highest **total damage ($)** on end-of-day recap.

| Secondary stats | Use |
|-----------------|-----|
| Peak storm mode | Tie-break, badges |
| Zones crossed | Explorer XP (future) |
| Largest single-town $ | Highlight reel |

**Agency victory** (low casualties, evacuations) — **deferred** until agency phase.

---

# Match end

| Trigger | Result |
|---------|--------|
| **24:00** clock | Mandatory end → **recap screen** |
| All player storms dead (optional) | AI continues until midnight unless early end voted |

### Recap (required)

- Leaderboard: **damage $** per **player storm** and **AI storm**  
- Breakdown: wind / hail / flood / lightning $  
- CONUS damage heatmap  

See [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md).

---

# AI integration

- AI uses same **zone spawn**, **outlook-weighted** points, and **one storm** (unless difficulty adds extra AI entities).  
- Competes for ingredients and destruction $ on recap.

---

# Difficulty

Same CONUS map; [StormDifficultyDesign.md](StormDifficultyDesign.md) scales ingredients and thresholds.

---

# Long-term match types (future)

- **Campaign day chain** — persistent player level  
- **Ranked season** — fixed seed leagues  
- **Co-op storms** — shared line building  
- **Agency vs storm** — asymmetric day (far future)

No two days identical: **season + zone + seed + player routes**.
