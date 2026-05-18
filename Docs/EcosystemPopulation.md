# Ecosystem Population (Solo + AI)

**Goal:** Matches feel **alive** — no empty zones; competitive ingredient use without fake cheats.

---

## Targets (solo default)

| Role | Per match | Distribution |
|------|-----------|--------------|
| **Human storms** | 1 | Player choice |
| **AI storms** | **10–14** total | At least **1 per zone**; extra in high-risk zones of the day |
| **AI agency** | 0 until agency phase | Occupancy UI shows 0 |

**Rule:** Every zone has ≥1 **Storm 🤖** before day start unless player chose that zone (then still +0–1 AI for pressure).

---

## Zone weighting (daily seed)

After outlook generates “day’s hot zone” (e.g. Z05 moderate risk):

1. Sort zones by composite severe index.  
2. Assign extra AI to top 3 zones (+2 each).  
3. Guarantee minimum 1 in all 12.  
4. Cap total AI at `max_ai_storms` from difficulty.

| Difficulty | AI storms |
|------------|-----------|
| Easy | 8 |
| Normal | 11 |
| Hard | 14 |
| Extreme | 16 |

---

## Multiplayer (later MP1)

| Lobby humans | AI fill |
|--------------|---------|
| 2 storm humans | Fill to 12 total storms |
| 4 storm humans | Fill to 14 |

**Briefing occupancy** shows resulting 👤/🤖 per zone ([BriefingZoneOccupancy.md](BriefingZoneOccupancy.md)).

---

## Implementation

- `AIEcosystemSpawner` reads `EcosystemPopulation` config + `AtmosphereGrid` day risk.  
- Ships with **S11** refactor; interim: expand current 3 AI spawns toward zone-aware placement in M1.

---

## Document history

| Date | Note |
|------|------|
| 2026-05 | Minimum AI per zone; 10–14 storm ecosystem |
