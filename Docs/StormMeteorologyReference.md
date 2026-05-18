# Storm Meteorology Reference (Real Science → Game)

**Purpose:** Use **real forecast terms and ingredients** so design and UI match how meteorologists talk about storms.  
**Not a textbook:** Values are **simplified for gameplay**; ranges below come from operational guides, not exact simulation.

**Primary sources (public):**
- [NWS JetStream — Severe Weather / CAPE](https://www.noaa.gov/jetstream/upperair/severe-weather)
- [SPC — Explanation of Severe Weather Parameters](https://www.spc.noaa.gov/exper/mesoanalysis/begin.html)
- [SPC — Parcel / LCL / LFC / CAPE / CIN](https://www.spc.noaa.gov/exper/soundings/help/parcelvals.html)
- [NWS Louisville — Squall Line / Bow Echo / QLCS](https://www.weather.gov/lmk/squallbow)
- [NOAA NSSL — Thunderstorm Types](https://www.nssl.noaa.gov/education/svrwx101/thunderstorms/types/)
- [NWS — Lightning stepped leader](https://www.weather.gov/safety/lightning-science-initiation-stepped-leader)
- [ESTOFEX — Forecasting severe convective storms](https://www.estofex.org/guide/1_4_4.html) (shear / supercell thresholds)

**Game docs using this:** [StormSimulationVision.md](StormSimulationVision.md), [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md) (S1), [AtmosphericSimulation.md](AtmosphericSimulation.md)

---

## 1. The Four Ingredients (foundation)

Operational severe-weather forecasting treats **deep, moist convection** as needing four ingredients. Your daily map and routing should reflect all four:

| Ingredient | Real meaning | Typical forecast variables | Game role |
|------------|--------------|----------------------------|-----------|
| **Moisture** | Fuel for clouds/precip | Surface **dewpoint** (°F/°C), **precipitable water (PW)** | Low LCL, sustain rain/hail; dry air = death |
| **Instability** | Air wants to rise vertically | **CAPE** (J/kg), **lapse rates**, **CIN** (cap) | Updraft strength; cap blocks until **lift** |
| **Lift** | Mechanism to release instability | Fronts, **dryline**, **outflow boundaries**, terrain, low-level convergence | Triggers initiation along routes |
| **Shear** | Wind change with height | **Bulk shear** (0–6 km), **deep-layer shear**, **SRH** | Tilt updraft, supercell, tornado potential |

> **Mnemonic used in training:** *Moisture, Instability, Lift, Shear (MILS)* — same four ideas as “heat + humidity” but with correct names.

**Design rule:** A high-CAPE day with **no lift** or **no moisture** should still fail. A moist, lifted airmass with **weak shear** should make **pulse/multicell** storms, not supercells.

---

## 2. Thermodynamics (moisture & instability)

### Dewpoint (Td)

- **Definition:** Temperature to which air must be cooled (at constant pressure) to become saturated.  
- **Use:** Low-level moisture; higher Td → easier cloud base, heavier rain potential.  
- **Game field:** `surface_dewpoint` (display °F or °C, consistent in UI).  
- **Rough severe-weather context (U.S. plains):** Td ≥ ~55–60 °F (13–16 °C) often noted when significant severe is possible; higher for tropical setups.

### Relative humidity (RH)

- Derived from T and Td.  
- **Game:** Optional overlay; dewpoint + CAPE are more important for storms.

### Precipitable water (PW)

- **Definition:** Total water vapor in a column (mm or inches).  
- **Use:** Heavy rain / flash flood potential; tropical moisture plumes.  
- **Game field:** `precipitable_water` — boosts rain training and flood damage (D phase).

### Lifting Condensation Level (LCL)

- **Definition:** Height where a lifted surface parcel becomes saturated → **cloud base**.  
- **Use:** Low LCL + strong shear → higher tornado risk (rain-wrapped cores).  
- **Game:** `lcl_height_m` or tier (low / medium / high); affects visibility of wall cloud vs rain-wrapped.

### Convective Inhibition (CIN / CINH)

- **Definition:** Negative buoyancy area (J/kg) a parcel must overcome to reach the **LFC**. The **cap**.  
- **Use:** Suppresses storms until lift or heating breaks the cap.  
- **Game field:** `cin` — high |CIN| = need strong **lift** trigger or wait for daytime heating.

### Level of Free Convection (LFC)

- **Definition:** Level where parcel becomes warmer than environment and rises freely.  
- **Game:** Internal; storm “ignites” when path crosses LFC-releasing trigger (lift + enough CAPE).

### Convective Available Potential Energy (CAPE)

- **Definition:** Positive buoyancy integral (J/kg) from LFC to **equilibrium level (EL)**.  
- **Use:** Updraft strength potential (not 1:1 with speed due to water loading & **entrainment**).  
- **Game field:** `cape` — primary “fuel” consumed along route.  
- **Rough tiers (design, not law):**

| CAPE (J/kg) | Typical label |
|-------------|----------------|
| &lt; 500 | Weak / little convection |
| 500–1500 | Marginal |
| 1500–2500 | Moderate |
| 2500–4000 | Strong |
| &gt; 4000 | Extreme (use sparingly on map) |

### Equilibrium Level (EL)

- Top of positive buoyancy; anvil spread near this level.  
- **Game:** Caps max tower height / visual tier.

### Entrainment

- **Definition:** Dry environmental air mixed into updraft, evaporationally cooling it.  
- **Use:** Kills storms in dry slots (high plains dryline west side).  
- **Game:** Moving into low Td / high CIN dry air → **organization** loss (vision doc).

### Lapse rate

- Temperature decrease with height; steep lapse rates aid instability.  
- **Game:** Optional `lapse_rate_700_500` tier bundled into instability index.

---

## 3. Kinematics (wind & shear)

### Environmental wind / steering flow

- Storms **advect** with mean wind (deeper layers steer MCS; low-mid levels steer supercells).  
- **Game:** `steering_wind_ms` vector on grid — blends with player path (S2).

### Bulk wind shear (0–6 km)

- **Definition:** Vector wind difference between two levels (often surface–6 km).  
- **Use:** Updraft tilt; separates precipitation from updraft; supercell environments often **~15–20 m/s** or more in 0–6 km layer (operational rule-of-thumb, region-dependent).  
- **Game field:** `bulk_shear_0_6km` (m/s).

### Deep-layer shear vs low-level shear

- **0–1 km**, **0–3 km** shear matter for tornadoes and storm organization.  
- **Game:** `low_level_shear` tier for tornado gate.

### Storm-relative helicity (SRH)

- **Definition:** Streamwise vorticity ingested into storm-relative updraft (m²/s²), commonly **0–1 km** and **0–3 km** layers.  
- **Use:** Better tornado / mesocyclone predictor than shear alone in many cases.  
- **Game field:** `srh_0_1km`, `srh_0_3km` — rotation score input.  
- **Rough severe-weather context:** Higher SRH (e.g. 150–300+ m²/s² in favorable setups) increases tornado risk when paired with strong updraft.

### Hodograph / veering

- **Veering** winds (clockwise with height in NH) support streamwise vorticity for supercells.  
- **Game:** Phase 2+; S1 can use SRH as consolidated proxy.

### Storm-relative winds

- Wind field relative to moving storm; affects inflow and supercell type (right-mover vs left-mover).  
- **Game:** Supercell **right-deviate** bias when shear + CAPE thresholds met (NH default).

---

## 4. Lift mechanisms (map triggers)

| Mechanism | Real process | Game trigger examples |
|-----------|--------------|------------------------|
| **Cold front** | Dense air undercuts warm moist air | Line of CAPE release along boundary |
| **Warm front** | Gentle overrunning | Stratiform rain band, slower growth |
| **Dryline** | Sharp moisture gradient plains | High CAPE east, entrainment death west |
| **Outflow boundary / gust front** | Rain-cooled **cold pool** | New cells along boundary; storm propagation |
| **Sea / lake breeze** | Mesoscale convergence | Coastal initiation |
| **Orographic lift** | Terrain forcing | Mountain lee / upslope zones |

**Cold pool** (downdraft-driven): rain-cooled air spreads at surface; drives **gust front**, MCS propagation, and **outflow-dominated** squall modes ([NSSL MCS material](https://www.nssl.noaa.gov/education/svrwx101/thunderstorms/types/)).

---

## 5. Storm types & modes (real → game enum)

### Ordinary / pulse convection

- Short-lived; collapse when cold pool undercuts updraft.  
- **Game:** `PULSE` — weak destruction, quick death if route bad.

### Multicell cluster

- Multiple cells at various stages; new cells on flanks.  
- **Game:** `MULTICELL` — messy reflectivity, moderate rain.

### Supercell

- **Definition:** Thunderstorm with **persistent rotating updraft (mesocyclone)**.  
- Requires strong **shear** + adequate **CAPE/moisture**; dynamically driven as well as thermodynamic.  
- **Right mover / left mover:** Propagation relative to mean wind and shear (NH: classic supercell often **right-moving**).  
- **Game:** `SUPERCELL` — mesocyclone score, hail core, hook echo possible.

### Mesocyclone

- **Definition:** Storm-scale vortex, typically **2–10 km** diameter, rotating updraft.  
- **Game stat:** `mesocyclone_strength` (0–100), gates tornado + hook.

### Squall line / QLCS

- **Squall line:** Linear convection, often ahead of cold front or in MCS.  
- **QLCS (Quasi-Linear Convective System):** Line-dominated severe system ([NWS](https://www.weather.gov/lmk/squallbow)).  
- **Game:** `LINE` / `QLCS` after merged cells + parallel motion.

### MCS (Mesoscale Convective System)

- Organized cluster or line, may last many hours, covers large area.  
- **Game:** Parent entity when multiple cells share cold pool / stratiform region.

### Bow echo

- **Definition:** Radar bowing segment in line — often **damaging straight-line winds** (rear inflow).  
- **Game:** `BOW` — max wind destruction swath (D phase).

### Derecho

- **Definition:** Long-lived, widespread **straight-line wind** event with MCS/bow.  
- **Game:** Rare high-end `DERECHO` flag when bow sustains path length + wind threshold.

### Balanced vs cold-pool-dominated MCS

- **Balanced:** Trailing stratiform rain, updraft/down draft couplet.  
- **Cold-pool dominant:** Outflow leads propagation; fast forward motion.  
- **Game:** Sub-mode on `LINE` affecting speed and damage type.

---

## 6. Radar & visual signatures (readable in 2D)

| Term | What it is | Game use |
|------|------------|----------|
| **Reflectivity** | Radar return intensity (dBZ) | Precip core color |
| **Hook echo** | Reflectivity hook around mesocyclone | UI when rotation + precip wrap |
| **Bow echo** | Bulge along line | Severe wind warning graphic |
| **Bounded weak echo region (BWER)** | Weak reflectivity in intense updraft | Optional supercell “hail core aloft” tell |
| **VIL** (Vertically Integrated Liquid) | Liquid water column | Hail size potential proxy |
| **Wet-bulb zero height** | Melting level | Hail vs rain at surface |

---

## 7. Hail & tornado (severe products)

### Hail

- Forms where strong updraft supports **supercooled water** growth aloft; size ∝ updraft strength + residence time.  
- **Game:** `hail_diameter_mm` tier (pea → golf → baseball) from CAPE + updraft + `wet_bulb_zero` + time in core.

### Tornado

- Requires **mesocyclone** + low-level **stretching** (often strong **SRH**, low LCL helps visibility).  
- **Rope → cone → wedge:** morphology by vortex width/intensity (spotter / survey language).  
- **Game:** Emergent from `mesocyclone` + `srh_0_1km` + sustained ingestion — not a button.

### Wall cloud / funnel cloud

- **Wall cloud:** Lowering under mesocyclone.  
- **Funnel cloud:** Condensation funnel not yet debris-connected.  
- **Tornado:** Debris / contact circulation at surface.

---

## 8. Lightning (real terms → game FX)

| Term | Meaning | Game |
|------|---------|------|
| **IC (intracloud)** | Discharge within cloud | Frequent branching leaders in anvil |
| **CC (cloud-to-cloud)** | Between clouds | Optional distant branches |
| **CG (cloud-to-ground)** | Leader connects to ground | Rare strikes, damage, thunder delay |
| **Stepped leader** | Downward branched ionization path | Visual fork algorithm (S6) |
| **Return stroke** | Bright upward current — what we “see” | Flash on CG hit |
| **Anvil crawler** | Spreading discharges along anvil | IC during mature stage |

**Charge structure (simplified):** Lower/mid negative, upper positive — drives IC vs CG ([NWS lightning science](https://www.weather.gov/safety/lightning-science-initiation-stepped-leader)).

**Thunder:** Sound arrives ~3 seconds per km (5 seconds per mile) after CG — use for immersion.

---

## 9. Parameters for daily briefing (S9 overlay list)

**Minimum set (S1 grid):**

| Variable | Units | Briefing label |
|----------|-------|----------------|
| `cape` | J/kg | CAPE |
| `cin` | J/kg | Cap (CIN) |
| `surface_dewpoint` | °F or °C | Dewpoint |
| `surface_temperature` | °F or °C | Temperature |
| `precipitable_water` | mm or in | Precip. water |
| `bulk_shear_0_6km` | m/s or kt | Wind shear (0–6 km) |
| `srh_0_1km` | m²/s² | SRH (0–1 km) |
| `steering_wind` | m/s, direction | Steering wind |
| `lcl_height` | m AGL | Cloud base (LCL) |

**Phase 2+ optional:** `lapse_rate`, `theta_e`, `effective_srh`, `significant_tornado_parameter` (STP) as composite “tornado risk” index for UI only.

---

## 10. Storm motion (why path planning matters)

Real storm motion ≈ **advection** (steering flow) + **propagation** (development along boundaries / cold pool).

| Storm type | Motion tendency (NH, simplified) |
|------------|--------------------------------|
| Ordinary cell | With low-level steering |
| Supercell | Often **right** of mean wind; speed depends on shear/CAPE |
| Squall line / MCS | Along line + cold-pool push |
| Bow echo | Acceleration along leading bulge |

**Game (S2):** `velocity = blend(planned_path, steering_wind, propagation_vector(cold_pool, mode))`

---

## 11. Difficulty scaling (ingredients & thresholds)

Difficulty changes **how much** of the atmosphere you need and **how forgiving** mistakes are — not the names on the HUD.

| Tier | Ingredients on map | Thresholds to evolve | Routing & merges |
|------|--------------------|----------------------|------------------|
| **Easy** | More CAPE/moisture; weaker cap; slower depletion | Lower bars — strong storms easier solo | Forgiving paths |
| **Normal** | Baseline | Reference tiers in this doc | Standard four-ingredient play |
| **Hard** | Tighter supply; faster depletion | Higher bars | Good routes; merges help lines/bows |
| **Extreme** | Scarce axes; harsh entrainment | Near-realistic bars | Near-perfect paths; **cooperation often required** for top modes |

**Player summary:** [StormPlayerCheatSheet.md](StormPlayerCheatSheet.md)  
**Multiplier tables:** [StormDifficultyDesign.md](StormDifficultyDesign.md)

---

## 12. What we deliberately simplify

| Real science | Game simplification |
|--------------|---------------------|
| Full sounding/skew-T | Grid fields + tiers |
| Microphysics schemes | Hail/lightning scores from CAPE + updraft + time |
| Numerical weather prediction | Daily **seeded** synoptic pattern |
| Exact m/s thresholds | Tunable per region/map |
| Climate change / radiation | Diurnal CAPE bump optional |

Always show **real names in UI** with short tooltips (see glossary in [StormSimulationVision.md](StormSimulationVision.md)).

---

## 13. Glossary index (quick)

| Term | One line |
|------|----------|
| CAPE | Updraft fuel (J/kg) |
| CIN | Cap — must break to ignite |
| LCL | Cloud base height |
| LFC | Free convection begins |
| EL | Anvil top / equilibrium |
| Td | Surface moisture |
| PW | Column moisture |
| Bulk shear | Wind change 0–6 km |
| SRH | Streamwise rotation intake |
| Mesocyclone | Rotating updraft |
| Gust front | Cold pool leading edge |
| Entrainment | Dry air killing updraft |
| Hook echo | Rotation + precip signature |
| Bow echo | Severe line wind signature |
| QLCS | Line severe system |
| MCS | Mesoscale cluster/line system |
| IC / CG | In-cloud vs ground lightning |

---

## Document history

| Date | Note |
|------|------|
| 2026-05 | Initial reference from NOAA/NWS/SPC/NSSL operational concepts |
