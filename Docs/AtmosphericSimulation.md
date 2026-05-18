# Atmospheric Simulation

# Philosophy

StormGame uses **semi-realistic** atmospheric simulation based on **operational severe-weather concepts** (not arcade bars).

**Authoritative term list:** [StormMeteorologyReference.md](StormMeteorologyReference.md)  
**Vision:** [StormSimulationVision.md](StormSimulationVision.md)  
**Grid implementation:** [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md) — **S1**

The goal is:
- believable weather behavior using **real field names** (CAPE, CIN, Td, SRH, etc.)
- strategic routing gameplay (four ingredients: **moisture, instability, lift, shear**)
- dynamic ecosystems (player + AI consume and deplete the same map)

Gameplay readability is more important than running a full NWP model, but **UI labels must match real meteorology**.

---

# The Four Ingredients

Every thunderstorm day is evaluated on:

| Ingredient | Key parameters |
|------------|----------------|
| **Moisture** | Surface **dewpoint (Td)**, **precipitable water (PW)** |
| **Instability** | **CAPE**, **CIN** (cap), lapse rates (optional) |
| **Lift** | Fronts, **dryline**, **outflow boundaries**, terrain, convergence |
| **Shear** | **Bulk shear (0–6 km)**, **SRH (0–1 km)**, steering wind |

A high-CAPE map with no moisture or no lift should **not** produce severe storms.

---

# Grid Fields (S1 target)

See [StormMeteorologyReference.md](StormMeteorologyReference.md) §9 for units and tooltips.

| Field | Role |
|-------|------|
| `cape` | Updraft potential; depleted by ingestion |
| `cin` | Suppresses initiation until lift/heating |
| `surface_dewpoint` | Moisture; entrainment penalty if low |
| `surface_temperature` | Instability with Td; urban modifier |
| `precipitable_water` | Heavy rain / training |
| `bulk_shear_0_6km` | Updraft tilt; supercell gate |
| `srh_0_1km` | Mesocyclone / tornado potential |
| `steering_wind` | Storm advection |
| `lcl_height` | Cloud base / tornado visibility |
| `lift_mask` or boundaries | Where cap can break |

Legacy prototype **humidity / heat / instability** bars map to these fields during migration (Td + CAPE + SRH, not 1:1 rename in code yet).

---

# Environmental Interactions

## Mountains
- **Orographic lift** — localized CAPE release, lee dryness (entrainment)

## Oceans / lakes
- High **Td** and **PW** flux; lake breeze **lift**

## Cities
- **Urban heat island** — modest temperature bump
- Destruction targets (D phase) — see [DestructionSystem.md](DestructionSystem.md)

## Deserts / dryline
- Low **Td**, high **CIN** west of dryline — **entrainment** death

## Forests
- Moisture flux (minor Td boost)

---

# Storm–Atmosphere Feedback

- Storm passage **depletes** CAPE and moisture in footprint
- **Cold pool** / **gust front** leaves boundary that acts as **lift** for next cells
- Overlapping storms: **outflow** competition, merge into **MCS/QLCS** (vision doc)

---

# Atmospheric Lifecycle (real order)

1. Moisture accumulation (**Td**, **PW**)
2. Instability buildup (**CAPE**, break **CIN** with **lift**)
3. Initiation at boundary (tower, **LCL**)
4. Updraft through **LFC**; growth to **EL** (anvil)
5. Cold pool / **gust front**; mode selection (pulse, supercell, line)
6. Severe products (hail, wind, **CG** lightning, tornado if **SRH** + mesocyclone)
7. Dissipation (entrainment, depleted environment, undercut)

---

# Simulation Goals

The atmosphere should feel:
- alive
- dynamic
- reactive
- emergent

Every match should evolve differently based on **seeded synoptic fields**, not random stat ticks.
