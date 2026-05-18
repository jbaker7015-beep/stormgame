# Briefing Zone Occupancy (Multiplayer)

**Parent:** [USMapAndZonesDesign.md](USMapAndZonesDesign.md) briefing flow  
**Networking:** [MultiplayerDesign.md](MultiplayerDesign.md)  
**Agency role (deferred):** [WeatherAgencyDesign.md](WeatherAgencyDesign.md)

---

## Purpose

During **briefing** (before **00:00**), show **live counts** of who chose each of the **10 zones** so players can:

- Avoid overcrowded zones (ingredient competition)  
- Seek high-risk zones for damage potential  
- See **agency** presence before committing *(when agency ships)*

Counts split **human vs AI** for **both** Storm and Agency factions.

---

## UI layout

### CONUS map (all zones)

Each zone polygon displays a compact badge:

```
Z05 Central Plains
Storm  👤2  🤖3
Agency 👤1  🤖1
```

- **👤** = human players committed  
- **🤖** = AI slots assigned for this match  
- Color: neutral white; highlight **player’s committed zone** in accent  

Optional **heat tint** on zone fill: green (empty) → yellow → red (crowded) based on total storm 👤+🤖.

### Zone zoom panel

When zoomed into a zone, repeat counts in a sidebar **Occupancy** card plus:

- % of lobby storm players in this zone  
- “Busiest storm zone today” flag if #1  
- Agency line hidden in solo-storm-only builds until agency phase  

### Legend (always visible in multiplayer briefing)

| Symbol | Meaning |
|--------|---------|
| Storm 👤 | Human storm players |
| Storm 🤖 | AI storms |
| Agency 👤 | Human Weather Service |
| Agency 🤖 | AI Weather Service |

Link to [StormPlayerCheatSheet.md](StormPlayerCheatSheet.md) — “crowded zone” strategy.

---

## When counts update

| Event | Effect |
|-------|--------|
| Player opens briefing | Sees current server state (AI pre-seeded from lobby) |
| Player **confirms zone** | `+1` human storm or agency in that zone |
| Player **changes zone** (before spawn lock) | `-1` old zone, `+1` new zone |
| Player **leaves lobby** | `-1` in committed zone |
| Lobby adds AI backfill | `+1` 🤖 in assigned zone |
| Briefing timer ends | Counts **frozen**; late joiners not allowed (config) |

**Spawn pick** does not change zone occupancy (zone already committed).

---

## Data model (server authoritative)

```text
ZoneOccupancy[zone_id] = {
  storm_human: int,
  storm_ai: int,
  agency_human: int,   // 0 until agency enabled
  agency_ai: int
}
```

- Replicated to all clients in `BRIEFING` state only.  
- After `00:00`, optional HUD can show “storms active in zone” but not briefing picker.

---

## Privacy & fairness

| Rule | Rationale |
|------|-----------|
| **No player names** on CONUS during briefing | Prevents spawn camping |
| **No spawn coordinates** until day start | Fair storm starts |
| Counts are **committed** players only, not browsing | Hovering zone ≠ counted |
| Ranked: show exact counts; Casual: optional “Low / Med / High” buckets | Accessibility |

---

## Solo & vs AI matches

| Mode | Display |
|------|---------|
| Solo | Storm 👤 `0` or hidden; Storm 🤖 shows ecosystem size |
| Storm-only multiplayer | Agency rows show `0` or hidden |
| Full asymmetric (future) | All four cells active |

---

## Agency briefing (deferred, designed now)

Agency players use the **same CONUS briefing** and **same occupancy badges**:

1. Pick **operational zone** (where HQ / radar focus lives) — commits `Agency 👤`.  
2. AI agencies distributed at lobby creation → `Agency 🤖`.  
3. Storm players see agency counts when choosing zones — informs expected resistance.

Implementation ships with agency phase; **M7** reserves UI slots and network fields.

---

## Implementation

| Phase | Work |
|-------|------|
| **M7** | `ZoneOccupancyTracker`, replicate in briefing, UI badges |
| **MP1** | Lobby roles, AI slot assignment per zone, briefing timer |
| **Agency+** | Enable agency_human / agency_ai columns |

**Depends:** M4 zone zoom UI, multiplayer lobby (MP1).

---

## Document history

| Date | Note |
|------|------|
| 2026-05 | Storm + Agency human/AI per-zone counts during briefing |
