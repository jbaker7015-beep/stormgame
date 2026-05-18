# Climate Zones (12) — Historical Basis

**Implementation:** `Systems/Config/climate_zone_config.gd`  
**Parent:** [USMapAndZonesDesign.md](USMapAndZonesDesign.md)

Twelve zones give enough diversity for **tornadoes, hurricanes, floods, blizzards, derechos, fire-weather, monsoon** without micromanaging 50 states.

---

## Zone table

| ID | Name | Historical / geographic basis | Signature hazards (game) |
|----|------|------------------------------|-------------------------|
| **Z01** | Pacific Northwest | Marine west coast; ARK storms | Heavy rain, winter wind, modest CAPE |
| **Z02** | California | Mediterranean coast; Sierra lee | Dry summer; ARK flood winter; fire-weather adjacency |
| **Z03** | Desert Southwest | Sonoran/Mojave; North American monsoon | Dry CIN; summer monsoon burst; microbursts |
| **Z04** | Southern Plains | TX/OK dryline; hail alley south | Dryline; supercells; large hail |
| **Z05** | Central Plains | Tornado Alley (KS/NE/OK) | Classic supercell; tornado max |
| **Z06** | Gulf Coast | Western Gulf / LA moisture | Hurricane landfall; training rain |
| **Z07** | Southeast | Gulf return flow; Piedmont | Air-mass storms; QLCS; tropical remnants |
| **Z08** | Florida Peninsula | Peninsular tropics | Daily sea-breeze; hurricane; extreme PW |
| **Z09** | Great Lakes | Lake-effect snow belt | Winter blizzard; summer MCS/derecho |
| **Z10** | Northeast | Nor’easter coast; mid-Atlantic | Winter storm; summer severe; coastal flood |
| **Z11** | Rocky Mountains | High plains lee / Front Range | Upslope hail; dry microburst; snow |
| **Z12** | Ohio & Tennessee Valley | Ohio River / TN valleys | Flood training; warm-season MCS |

---

## Season modifiers (Northern Hemisphere)

Applied as multipliers on zone **baselines** when seeding the day:

| Season | Plains (Z04–Z05) | Gulf/FL (Z06–Z08) | Lakes/NE (Z09–Z10) | SW (Z03) |
|--------|------------------|-------------------|---------------------|----------|
| **Spring** | CAPE ↑ shear ↑ | Moderate | Moderate | Dry |
| **Summer** | Strong CAPE | Max moisture | Humid | Monsoon peak |
| **Fall** | Secondary severe | Hurricane tail | Moderate | Fading monsoon |
| **Winter** | Low CAPE | Mild storms | Blizzard / nor’easter | Cool dry |

---

## Future hazard packs (not separate zones)

| Hazard | Primary zones |
|--------|----------------|
| Hurricane | Z06, Z07, Z08 |
| Blizzard | Z09, Z10, Z11 |
| River flood | Z06, Z07, Z12 |
| Derecho / MCS | Z05, Z07, Z09, Z12 |
| Tornado max | Z04, Z05 |

---

## CONUS art mapping

Until full CONUS mesh ships, prototype **play rect** uses **west → east** zone layout matching table order. M2 art replaces shapes; **zone IDs stay stable**.

---

## Document history

| Date | Note |
|------|------|
| 2026-05 | 12 zones from historical U.S. climate regions |
