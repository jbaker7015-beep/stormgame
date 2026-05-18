# Map Design

# Philosophy

StormGame uses a **continental United States (CONUS)** strategic map — recognizable, readable, and built for weather gameplay.

**Authoritative zone & briefing spec:** [USMapAndZonesDesign.md](USMapAndZonesDesign.md)  
**Day clock & recap:** [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md)

The map is not a hyper-realistic terrain simulator. It prioritizes:
- **10 weather-based climate zones**
- **Seasonal** variation
- **2.5D briefing** presentation (terrain pop, cities, major roads)
- Performance-friendly atmosphere grids

---

# Geographic scope

- **Continental United States** play space  
- **10 climate zones** (player may spawn in any zone)  
- Oceans, Gulf, Great Lakes at margins for moisture/tropical influence  
- **State borders** — subtle, for readability and future alerts  

---

# Ten weather zones (summary)

| ID | Zone |
|----|------|
| Z01 | Pacific Northwest |
| Z02 | California Coast |
| Z03 | Desert Southwest |
| Z04 | Southern Plains |
| Z05 | Central Plains (Tornado Alley) |
| Z06 | Gulf Coast |
| Z07 | Southeast |
| Z08 | Florida Peninsula |
| Z09 | Great Lakes / Upper Midwest |
| Z10 | Northeast / Mid-Atlantic |

Full climate notes, seasons, and briefing flow: [USMapAndZonesDesign.md](USMapAndZonesDesign.md).

---

# Visual style

## Briefing map (2.5D)

- **2D base** with **3D-like** depth: extruded terrain, parallax, lit slopes  
- **Visible:** cities, towns, **major interstates**, zone outlines  
- **Ingredient overlay cuts:** CAPE, CIN, Td, shear, SRH, PW, lift, severe composite  
- **Click zone** → zoom → zone outlook → **random spawn picks**

## Gameplay map

- Same data; optimized for storm motion and damage overlays  
- **S12** may add true 3D; briefing can remain 2.5D

---

# Settlements (Mini Towns & Cities)

**Destruction targets:** [DestructionSystem.md](DestructionSystem.md)

| Type | Density | Role |
|------|---------|------|
| Hamlet / mini town | Common per zone | Routing practice, small $ damage |
| Town | Moderate | Mid objectives |
| City | Rare | High $ damage, heat island |

Distributed **per zone** along rivers, plains, coasts, interstate junctions.

---

# Major roads

- **Interstate highways only** on map art (I-5, I-10, I-40, I-80, I-95, etc.)  
- Readable on briefing terrain; optional pathing flavor later  
- Full street grids **not** required

---

# Seasons

**Spring / Summer / Fall / Winter** modify zone climate baselines when each **day** is seeded.

Examples:
- **Z05 Central Plains** — spring max severe  
- **Z08 Florida** — summer humidity / tropical  
- **Z09 Great Lakes** — winter lake-effect, summer MCS  

See [USMapAndZonesDesign.md](USMapAndZonesDesign.md).

---

# Atmospheric simulation

Region-based **atmosphere grid** per zone ([AtmosphericSimulation.md](AtmosphericSimulation.md)):
- CAPE, CIN, Td, shear, SRH, steering wind, lift boundaries  
- Active detail near storms; simplified background elsewhere  

---

# Long-term goals

Players feel like they are steering storms across a **living U.S.** — briefing like a forecast office, play like a chaser, recap like a damage survey.
