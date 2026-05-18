# Weather Agency System Design

> **STATUS: DEFERRED** — Do not implement until **storm (S0–S12)** and **destruction (D1–D4)** slices are complete.  
> **Order:** Storms → [DestructionSystem.md](DestructionSystem.md) (route through towns/cities) → **then** Agency.  
> **Storm work:** [StormSimulationVision.md](StormSimulationVision.md), [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md)  
> This document is kept for long-term asymmetric multiplayer design only.

---

## Overview

StormGame includes an asymmetric multiplayer role called the Weather Agency.

These players do not directly fight storms.

Instead, they reduce destruction through:
- forecasting
- warnings
- preparation
- emergency response
- infrastructure protection

This creates a realistic weather ecosystem where storms evolve naturally while weather agencies attempt to minimize damage and save lives.

---

# Briefing — zone selection (multiplayer)

Agency players use the **same CONUS briefing** as storms ([USMapAndZonesDesign.md](USMapAndZonesDesign.md)).

| Display | Meaning |
|---------|---------|
| **Agency 👤** | Human agency players who committed to operate in this zone |
| **Agency 🤖** | AI agency slots in this zone |

Storm players see **Agency** counts alongside **Storm 👤/🤖** when picking a zone ([BriefingZoneOccupancy.md](BriefingZoneOccupancy.md)).

Agency commits an **operational zone** during briefing (before **00:00**), same commit rules as storms — no exact HQ coordinates revealed to enemies until play.

**Implementation:** Occupancy UI and network fields ship in **M7**; agency gameplay later.

---

# Core Gameplay Philosophy

Weather Agency gameplay should feel:
- strategic
- intelligent
- reactive
- high pressure
- cooperative

The role should reward:
- prediction accuracy
- fast decision making
- proper warning timing
- storm analysis
- resource management

---

# Weather Agency Gameplay Loop

1. Monitor atmospheric conditions
2. Detect developing storms
3. Analyze storm trajectories
4. Issue warnings
5. Deploy mitigation systems
6. Reduce casualties and destruction
7. Earn funding and technology upgrades

---

# Agency Player Roles

## Meteorologist

Focus:
- storm analysis
- forecasting
- prediction models

Gameplay:
- track instability
- monitor radar
- identify dangerous storms
- predict evolution paths

Abilities:
- advanced radar scans
- future path prediction
- storm intensity analysis

---

## Emergency Manager

Focus:
- evacuation
- disaster response
- public safety

Gameplay:
- issue evacuation orders
- manage shelters
- deploy emergency teams

Abilities:
- faster evacuation
- panic reduction
- casualty reduction

---

## Infrastructure Specialist

Focus:
- protecting cities
- reinforcing buildings
- reducing damage

Gameplay:
- strengthen power grids
- flood barriers
- storm-resistant upgrades

Abilities:
- damage resistance
- repair systems
- emergency generators

---

# Warning System

Players issue weather alerts based on storm severity.

Examples:
- thunderstorm watch
- tornado warning
- hurricane evacuation
- flash flood alert
- blizzard warning

Correct warnings:
- save civilians
- reduce destruction
- earn funding

False warnings:
- reduce trust
- increase panic
- lower agency reputation

---

# Forecasting System

Weather agency players should use:
- radar
- atmospheric data
- storm signatures
- wind shear analysis
- humidity tracking

Forecasting should require skill and interpretation.

Storm behavior should not always be perfectly predictable.

---

# Population System

Cities contain civilian populations.

Population reacts to:
- warning quality
- evacuation timing
- agency reputation

Successful evacuations:
- reduce casualties
- increase funding
- improve agency rank

---

# Funding System

Weather agencies earn funding through:
- successful forecasts
- reduced casualties
- infrastructure protection
- accurate warnings

Funding unlocks:
- better radar
- faster communication
- improved defenses
- advanced technology

---

# Advanced Technology

Late-game technology may include:
- storm drones
- mobile radar trucks
- atmospheric monitoring satellites
- AI forecasting systems

Technology should improve prediction rather than directly stopping storms.

---

# Storm Interaction Philosophy

Weather agency players should influence outcomes without removing storm player freedom.

Storms remain dangerous and powerful.

Agency gameplay is about:
- adaptation
- preparation
- mitigation

not direct combat.

---

# Multiplayer Dynamics

This creates natural tension:
- storms attempt to maximize destruction
- agencies attempt to minimize damage

Both sides should feel powerful in different ways.

Storm players create chaos.

Agency players create order.

---

# Long-Term Vision

The ideal gameplay experience should feel like:
- a living weather ecosystem
- a realistic disaster management simulator
- a strategic multiplayer experience
- a battle between nature and preparation

The game should reward both destruction and prevention skill equally.