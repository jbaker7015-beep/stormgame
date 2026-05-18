# Storm Simulation Vision

**Status:** Design target (supersedes arcade prototype feel)  
**Scope:** Player/AI **storms only** — Weather Service / agency gameplay is **deferred** (see [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md)).  
**Real meteorology terms & ingredients:** [StormMeteorologyReference.md](StormMeteorologyReference.md) (NOAA/NWS/SPC-based)  
**Player cheat sheet:** [StormPlayerCheatSheet.md](StormPlayerCheatSheet.md) · **Difficulty:** [StormDifficultyDesign.md](StormDifficultyDesign.md)  
**U.S. map & briefing:** [USMapAndZonesDesign.md](USMapAndZonesDesign.md) · **Day & recap:** [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md)  
**Related:** [GameDesign.md](GameDesign.md), [AtmosphericSimulation.md](AtmosphericSimulation.md), [StormEvolutionTree.md](StormEvolutionTree.md)

---

## North Star

StormGame should feel like **steering a real convective storm** across a living map — not like **Twister.io** or Agar.io with weather paint.

| Today (prototype) | Target |
|-------------------|--------|
| Free WASD at ~280 px/s | **Planned path** along environmental flow; slow, heavy motion |
| Abstract humidity/heat bars | **Four ingredients:** moisture (Td, PW), instability (CAPE, CIN), **lift**, **shear** (bulk shear, SRH) — see [StormMeteorologyReference.md](StormMeteorologyReference.md) |
| Polygons that scale up | **Storm cells** that look and behave like **single-cell → multicell → supercell / squall structures** |
| Procedural beeps/buzz | **Recorded** wind, rain, hail, thunder |
| Simple flash lines | **Forked in-cloud lightning** + **occasional cloud-to-ground** strikes |
| Instant evolution thresholds | Evolution gated by **where you moved** and **what you depleted** |

**3D:** Always the long-term presentation goal. **Mechanics and atmosphere sim are proven in 2D first**, then visuals/camera migrate to 3D (volumetric clouds, sky lightning, terrain). Gameplay rules stay data-driven so the sim does not get rewritten twice.

---

## Design Pillars (Storm-First)

1. **Meteorology-inspired, gameplay-readable** — Real concepts (CAPE, shear, cold pools) drive outcomes; UI explains them in plain language.
2. **Movement is strategic, not twitch** — Success is *routing* through the right air, not dodging with WASD.
3. **Storms are fragile** — Bad routes, dry entrainment, or hostile interactions **weaken and kill** the cell; player **respawns** by picking a **new spawn** in their **original zone** (clock keeps running).
4. **The map is a shared pantry** — Ingredients are **finite per region per day**; storms (player + AI) **deplete** and **modify** what’s left.
5. **Storms interact** — Merge, compete, rob outflow, or strengthen each other when motion and mode align.
6. **Observe like a chaser** — Detached camera anywhere; **snap back** to your storm; **hover** for readable stats.

---

## Departure From Arcade Prototype

The current build validates systems (zones, evolution stages, AI, FX, audio plumbing). The next era **replaces** these feel targets:

- Remove **omnidirectional arcade speed** as the primary control scheme.
- Lengthen **time scales** (growth, movement, lightning cadence, match pacing).
- Tie **power** to **synoptic + mesoscale** conditions, not constant passive synthesis.
- Treat **special structures** (supercell, bow echo, hook echo, hail core) as **emergent modes**, not only stat thresholds.

---

## Player Storm Control (Target)

### Trajectory planning (replaces WASD)

1. Player **click-drags** on the map to set a **movement plan** (polyline or curved path with 1–3 waypoints).
2. Storm **commits** to that plan at **realistic speed** (tunable: e.g. 15–45 km/h effective on map scale, not instant turns).
3. **Actual track** = planned path **blended with**:
   - **Mean wind** (steering flow at storm depth)
   - **Storm-type propagation** (e.g. supercell deviates right of mean wind in classic setup; squall line advects with line-normal component)
   - **Cold-pool / outflow boundaries** (storms ride or stall along outflow)
4. Player may **replan** on a cooldown; sharp turns cost **organization** (temporary efficiency penalty).

### Why this feels more real

Real storms do not teleport; they **propagate** with environmental flow and their own **cold pools**. The player influences **where the cell tries to go**, not arbitrary 8-way thrust.

### Failure and respawn

- Sustained **negative budget** (dry air, low CAPE, hostile shear, eaten by dominant outflow) → **weakening → dissipation**.
- On death: brief **respawn picker** — new **random spawn candidates** in the **same zone** locked at briefing; player **chooses one** (may differ from first spawn). Prior map depletion **remains**; game clock **does not** reset.

---

## Camera (Target)

| Action | Behavior |
|--------|----------|
| Default | Follow own storm (soft lag, zoom by stage) |
| Pan / zoom | Free look anywhere on map |
| Snap | One key/button: camera returns to player storm |
| Inspect | Hover any storm (player, AI, merged) for stat panel |

---

## Tactical radar (in-day)

See [StormTacticalRadar.md](StormTacticalRadar.md).

| UI | Behavior |
|----|----------|
| **Bottom-right minimap** | TV-style reflectivity; **loops next 10 min** if storms stay on course |
| **`M` key** | Expand to **full zone** radar + forecast; **all player + AI storms** |
| Purpose | Decide to **replan** path or **continue** |

Not the same as pre-day CONUS briefing overlays.

---

## Match Day Flow (Storm Side Only)

*Weather Service is **far future**. One match = **one calendar day** (**00:00–24:00**) on the **continental U.S.** map.

**Full UX:** [USMapAndZonesDesign.md](USMapAndZonesDesign.md) · **Recap:** [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md)

### 0. CONUS briefing (before spawn)

1. **2.5D U.S. map** — terrain relief, **cities/towns**, **major interstates**, **10 zone** outlines.  
2. **General weather outlook** (procedural text for the day).  
3. Player cycles **ingredient overlay cuts** (CAPE, CIN, Td, shear, SRH, etc.).  
4. **Click a zone** (any of 10 climates) → **zoom** → **zone outlook** for that day.  
5. **Random spawn points** in zone (weighted by outlook) → player picks one.  
6. **Season** affects all zone baselines ([USMapAndZonesDesign.md](USMapAndZonesDesign.md)).

### 1. Daily atmosphere setup (seeded)

Each “day” generates a **synoptic snapshot** over the map using **operational-style fields** (full definitions: [StormMeteorologyReference.md](StormMeteorologyReference.md)):

| Field (real term) | Units (typical) | Game meaning |
|---------------------|-----------------|--------------|
| **CAPE** | J/kg | Updraft fuel; consumed along storm path |
| **CIN** (cap) | J/kg | Suppresses storms until **lift** or heating breaks it |
| **Surface dewpoint (Td)** | °F / °C | Low-level moisture; entrainment death if too low |
| **Precipitable water (PW)** | mm / in | Heavy rain / training potential |
| **Surface temperature** | °F / °C | Instability with Td; urban heat islands |
| **Bulk shear (0–6 km)** | m/s | Updraft tilt; supercell threshold (~15–20 m/s rule-of-thumb) |
| **SRH (0–1 km)** | m²/s² | Streamwise rotation → mesocyclone / tornado potential |
| **Steering wind** | m/s, dir | Advection; blends with planned path |
| **LCL** | m AGL | Cloud base; low LCL aids tornado visibility |
| **Lift triggers** | — | Cold/warm front, **dryline**, **outflow boundary**, terrain, lake breeze |

**Four ingredients check:** moisture + instability + lift + shear must align for severe modes — not CAPE alone.

Displayed as **map overlays** during a **planning phase** (duration TBD, e.g. 60–120 s single-player).

### 2. Starting point selection

- Player already chose **zone** on briefing map; spawn is one of **several RNG points** weighted by local outlook.  
- Good spawns sit near **lift + moisture + CAPE**; bad spawns teach failure quickly.  
- **One active storm** per player at start; skill tree may allow more ([PlayerProgressionDesign.md](PlayerProgressionDesign.md)).

### 3. Active day (00:00 → 24:00)

- Accelerated game clock (configurable real-time length).  
- Storms move across **CONUS** (any zone), ingest, deplete, merge.  
- Goal: **largest severe storm practical** + **maximum destruction $** ([DestructionSystem.md](DestructionSystem.md)).  
- Map state persists for the day (depletion, damage scars).

### 4. End-of-day recap

- At **24:00**, show **damage in dollars ($)** per **player storm** and **AI storm**.  
- Breakdown by wind / hail / flood / lightning; CONUS damage map.

---

## Atmospheric Ingredients & Depletion

### Ingestion

Storm absorbs along its **path and footprint** (inflow sector + updraft core):

- Consumes local **CAPE**, **moisture**, and **instability** from grid/zone cells.
- Gains **organization** when path matches favorable **shear + moisture + lift**.
- Gains **rotation score** when shear/helicity align with sustained updraft (supercell path).

### Depletion

- Cells passed by any storm have **reduced** CAPE/moisture until **slow recovery** (hours-scale in-universe, minutes in match — tunable).
- Prevents infinite farming of one county.
- Creates **competition** between player and AI without fake damage numbers.

### Wrong-air penalties

- **Dry entrainment:** movement into dry slots (low **Td**, high **CIN** west of **dryline**) → collapse.
- **Cap (CIN):** too much inhibition without **lift** → cannot reach **LFC**; storm stalls and dies.
- **Hostile shear:** weak tilt / wrong shear → pulse only; strong negative shear pairing can disrupt organization.

---

## Storm Interaction

When two cells overlap or their **outflow / inflow** regions meet:

| Interaction | Condition (simplified) |
|-------------|-------------------------|
| **Merge** | Compatible motion, shared boundary, not dominant cold-pool clash |
| **Line consolidation** | Parallel motion + time → **squall line** segment |
| **Weaken** | Dominant downdraft undercuts neighbor updraft |
| **Rob moisture** | Stronger inflow wins local moisture flux |
| **Orphan satellite** | Smaller cell becomes flank cell of larger system |

Merged entity uses **combined mass + mode rules** (see Storm Modes).

---

## Storm Modes & Structures (Meteorology → Game)

Modes are **emergent** from stats + environment + motion history, not only level numbers.

### A. Ordinary cell lifecycle

1. **Tower / cumulus** — shallow, little precip  
2. **Pulse storm** — short severe pulse, quick death (bad routing lesson)  
3. **Multicell cluster** — new cells on flank; messy structure  

### B. Supercell

**Requirements (simplified):** sustained updraft + strong shear/helicity + adequate moisture.

**Behaviors:**

- Persistent **rotating updraft** (mesocyclone score).
- **Right-mover** bias along shear (configurable per hemisphere/map).
- **Hail core** — high reflectivity zone aloft → surface hail swath if path holds.
- **Hook echo** signature when rotation and precipitation wrap (UI/radar-style overlay for readability).

**Player goal route:** intercept **moisture + instability** along shear vector without ingesting too much cold pool.

### C. Squall line / MCS

**Formation:** multiple cells merge with **parallel** motion into a line.

| Mode | Real-world analog | Game feel |
|------|-------------------|-----------|
| **Balanced MCS** | Trailing stratiform, coupled up/down draft | Steady rain swath, moderate wind |
| **Cold-pool dominant** | Outflow-led propagation ([gust front](https://www.nssl.noaa.gov/education/svrwx101/thunderstorms/types/)) | Fast forward motion, dusty leading edge |
| **Bow echo** | QLCS bow segment; rear-inflow jet | Bulging radar bow, extreme straight-line wind |
| **Derecho** (rare) | Long-lived widespread wind event | High score wind destruction if sustained |
| **Embedded supercell** | Rotating cell within line | Localized mesocyclone + hail max |

Cold-pool strength affects **how fast the line crawls** and **who gets undercut**.

### D. Hail core

- Sub-structure of supercell or intense multicell.
- Stats: **hail size tier**, **core aloft strength**, **surface swath width**.
- Requires **strong updraft + sufficient CAPE + frozen-layer depth** (simplified tier table).

### E. Tornado (high-end)

- Not a separate “arcade ability” — emerges from **mesocyclone** + **low-level stretch** + sustained ingestion.
- **Rope → cone → wedge** tiers by rotation + longevity (aligns with [StormEvolutionTree.md](StormEvolutionTree.md) tornado path).
- **Hook echo** UI when rotation crosses threshold (education + telegraph).

---

## Lightning (Target)

### Intracloud (IC) — primary

- **Stepped leaders** and branches within cloud ([NWS lightning science](https://www.weather.gov/safety/lightning-science-initiation-stepped-leader)).
- Mostly **IC** / anvil crawlers; frequency scales with charge separation (updraft + ice phase — abstracted).
- **No surface damage** from IC alone.

### Cloud-to-ground (CG) — secondary

- **Stepped leader** meets upward **streamer** → bright **return stroke** (visible flash).
- **Occasional CG** to terrain/settlements under mature core.
- **Thunder** delayed ~3 s/km (~5 s/mi) from strike for immersion.
- CG more likely with strong updraft, lower **LCL**, mature supercell.

### Audio

- IC: short crackle / rumble mix  
- CG: sharp crack + rolling thunder, positioned by distance  

---

## Audio (Target)

**Replace procedural loops** with **licensed/recorded** storm libraries:

| Layer | Source |
|-------|--------|
| Ambient wind | Field recordings, looped with variation |
| Rain | Light / moderate / heavy stems |
| Hail | Impacts on roof/ground layers |
| Thunder | Close vs distant samples, time-aligned to CG |

**Mixing:** intensity from storm stats + camera distance + occlusion (city vs open plain).  
Procedural synth remains **fallback only** for dev builds.

---

## Visuals (Target)

**2D milestone:** Satellite-style map + **radar-like** precipitation cores, anvil sketch, hook/bow outlines for readability.  
**3D milestone:** Volumetric cloud body, internal lightning, sun angle, rain shafts.

Storm should read as:

- **Updraft core** (bright tower)
- **Rain shaft** / stratiform region
- **Anvil** spread downshear
- **Flanking line** cells when multicell
- **Hail core** as high-reflectivity blob
- **Wall cloud / funnel** when tornado-ready

---

## Storm Stat Panel (Hover)

Readable labels (tooltips for jargon):

| Stat (real term) | Tooltip hint |
|------------------|--------------|
| CAPE | Updraft fuel (J/kg) |
| CIN | Cap strength |
| Td | Surface dewpoint |
| PW | Precipitable water |
| Bulk shear 0–6 km | Tilt / supercell ingredient |
| SRH 0–1 km | Rotation intake |
| LCL | Cloud base |
| Updraft | Tower strength |
| Cold pool | Outflow / gust front push |
| Mesocyclone | Rotating updraft |
| Mode | Pulse / Multicell / Supercell / QLCS / Bow… |
| Hail | Estimated size tier |
| Organization | Storm health (dissipation if zero) |

---

## Destruction (After Storm Slice, Before Agency)

Storm players earn impact by **routing** through **mini towns and cities** on the map — not by pressing an attack button.

| Principle | Detail |
|-----------|--------|
| **Targets** | Hamlets, towns, cities placed as map settlements |
| **How damage happens** | Storm footprint + mode (wind, hail, flood, CG lightning) as the cell moves |
| **Player skill** | Grow the right mode, then **plan a path** that maximizes destruction |
| **Agency later** | Weather Service defends/evacuates **after** destruction slice exists |

Full spec: [DestructionSystem.md](DestructionSystem.md)  
Implementation: **D1–D4** in [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md) (after **S12**).

---

## Weather Service (Explicitly Deferred)

Forecasting, warnings, evacuations, infrastructure defense, and **dual-side planning** belong in a **later product phase** — **after storms (S) and destruction (D)** are fun and credible.

See roadmap: **Agency phase moved post–destruction vertical slice.**

---

## Success Criteria (Storm Vertical Slice)

- [ ] Player plans path; storm moves slowly along blended environmental track.  
- [ ] Wrong routes kill the storm; respawn picker offers new spawns in original zone.  
- [ ] Daily map shows CAPE/dewpoint/temp/shear; spawn choice matters.  
- [ ] Ingredients deplete; AI storms alter the same map.  
- [ ] Two storms can merge into line or supercell modes with distinct behavior.  
- [ ] Lightning forks in-cloud; CG strikes sometimes; thunder timed by distance.  
- [ ] Recorded wind/rain/hail/thunder mix replaces prototype synth.  
- [ ] Camera free-look + snap-back; hover stats on any storm.  
- [ ] Supercell, hail core, bow/hook **readable** on map/radar view.  

---

## Glossary (Quick Reference)

Full definitions, units, and source links: **[StormMeteorologyReference.md](StormMeteorologyReference.md)**

| Term | Meaning in-game |
|------|-----------------|
| **CAPE** | Updraft fuel (J/kg) |
| **CIN** | Cap — energy to break before LFC |
| **Td (dewpoint)** | Surface moisture |
| **PW** | Column moisture — heavy rain |
| **LCL / LFC / EL** | Cloud base / free convection / anvil top |
| **Bulk shear (0–6 km)** | Tilt; supercell environments |
| **SRH** | Rotation intake — mesocyclone/tornado |
| **Lift** | Front, dryline, outflow boundary, terrain |
| **Cold pool / gust front** | Outflow that propagates and triggers |
| **Mesocyclone** | Persistent rotating updraft |
| **QLCS / MCS** | Line severe system / mesoscale cluster |
| **Hook / bow echo** | Radar signatures for rotation / severe wind |
| **Entrainment** | Dry air killing updraft |
| **IC / CG** | In-cloud vs cloud-to-ground lightning |

---

## Document History

| Date | Note |
|------|------|
| 2026-05 | Initial vision: semi-realistic storm sim, trajectory control, deferred agency |
| 2026-05 | Destruction (towns/cities via route) scheduled after S12, before agency |
| 2026-05 | StormMeteorologyReference.md — real NOAA/NWS/SPC terms for ingredients |
