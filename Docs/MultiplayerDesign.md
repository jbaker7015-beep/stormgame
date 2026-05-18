# Multiplayer Design

# Philosophy

StormGame should support:
- single-player
- co-op
- PvP
- AI-populated matches

The multiplayer experience should feel like a living atmospheric ecosystem.

**Briefing occupancy:** [BriefingZoneOccupancy.md](BriefingZoneOccupancy.md)  
**Map & zones:** [USMapAndZonesDesign.md](USMapAndZonesDesign.md)

---

# Match Types

## Solo
Single player with AI storms and AI agencies.

---

## Co-op Storms
Players evolve storms together.

---

## PvP Storms
Storm players compete for atmospheric dominance.

---

## Agency vs Storms
Storm players compete against human weather agencies.

---

# Briefing phase (multiplayer)

All human players share one **CONUS briefing** before **00:00**.

### Zone occupancy (Storm + Agency)

Each of the **10 zones** shows live counts:

- **Storm 👤** — human storm players committed to zone  
- **Storm 🤖** — AI storms in zone  
- **Agency 👤** — human Weather Service committed *(deferred gameplay)*  
- **Agency 🤖** — AI agencies in zone *(deferred)*  

Updates replicate from **authoritative server** when players confirm or change zone.

**Purpose:** Pick less crowded zones for ingredients, or busier zones for PvP / destruction competition.

Details: [BriefingZoneOccupancy.md](BriefingZoneOccupancy.md).

### Briefing flow (multiplayer)

1. Lobby — roles, difficulty, season, AI fill count  
2. CONUS briefing — outlook, overlays, **zone occupancy badges**  
3. Each player: zone zoom → confirm zone → pick spawn  
4. Timer ends → **00:00** — all spawns go live together  
5. Play day → **24:00** recap ([DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md))

---

# Networking Philosophy

The game should use:
- authoritative server logic
- synchronized atmospheric systems
- optimized replication

### Replication priorities (briefing)

| Priority | Data |
|----------|------|
| High | `ZoneOccupancy` deltas, zone commit messages |
| Medium | overlay seed sync (same CAPE field for all) |
| Low | cosmetic briefing camera |

---

# Multiplayer Goals

- stable synchronization
- scalable storm counts
- smooth weather simulation
- dynamic ecosystems
- **informed zone choice** via occupancy UI

---

# Synchronization Priorities (gameplay)

Highest Priority:
- storm positions
- storm evolution
- destruction events
- weather alerts

Lower Priority:
- cosmetic particles
- ambient effects

---

# AI Integration

AI should seamlessly fill:
- empty player slots
- inactive regions
- ecosystem gaps

**Briefing:** AI storm/agency counts visible per zone **before** day start so humans know ecosystem density.

Players should not immediately know which **individual** storms are AI during play — only aggregate briefing counts.

---

# Match Flow

1. **Lobby** + role assignment  
2. **Shared briefing** (occupancy + outlook)  
3. Zone commit + spawn pick  
4. **00:00** atmospheric / storm start  
5. Escalation through game day  
6. **24:00** recap — damage $ leaderboard  

---

# Implementation phases

| Phase | Delivers |
|-------|----------|
| **M7** | Zone occupancy sync + UI (storm + agency fields) |
| **MP1** | Lobby, briefing timer, simultaneous day start |
| **MP2** | PvP storm replication hardening |
| **MP3** | Agency asymmetric + occupancy already wired |

Storm-first solo ships without MP1; occupancy UI can show AI-only counts.

---

# Long-Term Multiplayer Goals

- persistent worlds
- seasonal weather events
- ranked storm leagues
- cooperative disaster response
