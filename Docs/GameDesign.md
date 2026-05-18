# StormGame - Game Design Document

## Vision

StormGame is a **semi-realistic convective storm simulator** — players **route** storm cells through real meteorology-inspired ingredients (CAPE, moisture, shear) and grow **credible structures** (supercells, squall lines, hail cores, bow/hook echoes).

**Design authority (storm era):** [StormSimulationVision.md](StormSimulationVision.md)  
**Implementation plan:** [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md)

The early prototype used arcade movement (WASD, fast speeds) to validate systems; that feel is **legacy**, not the target.

Players begin as weak disturbances and evolve by **where they move** on a **depleting atmospheric map**, not by free omnidirectional speed.

Long-term: multiplayer ecosystem and **3D presentation**; **Weather Service / agency gameplay is deferred** until storm simulation is perfected.

The long-term vision is a multiplayer ecosystem where storms compete for atmospheric resources and evolve down different weather paths such as tornadoes, hurricanes, blizzards, and lightning superstorms.

---

# Core Design Philosophy

- Real meteorology inspired (CAPE, dewpoint, shear, cold pools, storm modes)
- **Strategic movement first** (planned path + environmental steering) — not twitch arcade
- Easy to learn forecasts; **deep routing and mode mastery**
- Highly scalable (grid atmosphere + data-driven storms)
- Emergent multiplayer when storm slice is proven
- **Recorded** storm audio; **forked lightning** + occasional ground strikes
- Visually satisfying **storm cells** (2D radar art → 3D volumetric)
- Destruction should feel earned, not immediate
- **Storms before agency** — see deferred Weather Service in roadmap

Storms should feel alive and evolving.

Players should experience the full lifecycle of atmospheric development rather than spawning as powerful storms instantly.

---

# Gameplay Loop

**Briefing (M phases):**

1. View **continental U.S.** map (2.5D terrain, cities, major roads, **10 climate zones**)
2. Read **general outlook**; cycle **ingredient overlay cuts** (CAPE, Td, shear, …)
3. **Click a zone** → zoom → **zone outlook** for that day (**season** matters)
4. Pick one **random weighted spawn** in that zone

**Storm day (S phases, 00:00–24:00):**

5. **One active storm** (multi-storm via skill tree later)
6. Plan routes; grow via real ingredients; develop modes (supercell, line, bow, …)
7. Die → pick a **new spawn** in your **original zone**; clock keeps running

**Destruction (D phases):**

8. Route through **towns/cities** for **maximum damage ($)**
9. **24:00 recap** — leaderboard of **$** per player/AI storm

**Later:** Player **levels & skill tree** (P); Weather Service (agency); multiplayer.

---

# Game Genre

- Semi-realistic weather simulator
- Evolution/progression game
- Multiplayer survival/competition
- Arcade destruction sandbox

---

# Primary Inspirations

- Real-world meteorology and storm structure (supercells, MCS, bow echoes)
- Weather radar / chaser documentaries
- Evolution of **storm mode**, not io-game growth
- *(Legacy prototype only)* — Agar.io-style speed was for early testing, not the vision

---

# Core Atmospheric Resources

**Use real meteorology terms in UI and design.** Full reference: [StormMeteorologyReference.md](StormMeteorologyReference.md).

## The four ingredients

| Ingredient | Real parameters | Game use |
|------------|-----------------|----------|
| **Moisture** | **Dewpoint (Td)**, **PW** | Sustain clouds/rain; dry entrainment kills storms |
| **Instability** | **CAPE**, **CIN** (cap) | Updraft fuel; cap needs **lift** to break |
| **Lift** | Fronts, **dryline**, **outflow boundary**, terrain | Initiate/concentrate convection |
| **Shear** | **Bulk shear 0–6 km**, **SRH** | Supercell, mesocyclone, tornado potential |

Legacy prototype **heat / humidity / instability** bars will migrate to these fields (S1).

---

## Key parameters (hover / briefing)

- **CAPE** (J/kg), **CIN**, **LCL**, **LFC** / **EL** (internal)
- **Surface temperature**, **surface dewpoint**
- **Precipitable water**
- **Steering wind**, **bulk shear**, **SRH (0–1 km)**
- **Mesocyclone** strength, **cold pool** / gust front

---

## Wind Shear & SRH

- **Bulk wind shear (0–6 km):** tilts updraft; supercell environments often ~15–20+ m/s (tunable, region-dependent).
- **Storm-relative helicity (SRH):** rotation intake; pairs with mesocyclone for tornado risk.

---

# Storm Evolution System

Players evolve through meteorological stages.

Each stage unlocks:
- new visuals
- new abilities
- new gameplay mechanics
- new upgrade paths

---

# Evolution Progression

## Stage 1 - Moisture Pocket
Gameplay:
- absorb humidity particles
- gather heat energy
- avoid dissipation

Abilities:
- slow movement
- small absorption radius

Goal:
Generate enough energy to create vertical lift.

---

## Stage 2 - Warm Air Updraft
Gameplay:
- create rising air columns
- increase instability
- pull nearby moisture inward

Abilities:
- vertical wind pull
- improved movement

Goal:
Form visible cloud structures.

---

## Stage 3 - Cumulus Cloud
Gameplay:
- begin rainfall
- increase storm mass
- absorb larger atmospheric zones

Abilities:
- rain generation
- larger size
- increased energy storage

Goal:
Reach thunderstorm thresholds.

---

## Stage 4 - Developing Thunderstorm
Gameplay:
- lightning begins
- stronger wind fields
- localized damage possible

Abilities:
- lightning strikes
- gust fronts
- heavier rain

Goal:
Develop severe weather conditions.

---

## Stage 5 - Mature Thunderstorm
Gameplay:
- strong winds
- hail formation
- stronger rainfall
- greater environmental interaction

Abilities:
- hail
- stronger downdrafts
- damage scaling

Goal:
Accumulate enough instability and shear for specialization.

---

# Storm Specialization Paths

Players eventually choose specialized evolution paths.

These are not locked permanently and may evolve further later.

---

## Tornado Path

Focus:
- rotation
- suction
- concentrated destruction

Mechanics:
- vortex formation
- debris absorption
- wind intensification

Possible Evolutions:
- rope tornado
- wedge tornado
- violent tornado

---

## Hurricane Path

Focus:
- size
- sustained power
- flooding
- storm surge

Mechanics:
- ocean heat absorption
- eye formation
- spiral rainbands

Possible Evolutions:
- tropical storm
- hurricane
- major hurricane
- hyper hurricane

---

## Blizzard Path

Focus:
- freezing
- snow accumulation
- visibility reduction

Mechanics:
- temperature control
- ice generation
- snowfall systems

Possible Evolutions:
- snowstorm
- blizzard
- super blizzard

---

## Lightning Superstorm Path

Focus:
- electrical activity
- chain lightning
- EMP-like weather effects

Mechanics:
- charge buildup
- lightning targeting
- atmospheric discharge

Possible Evolutions:
- electrical storm
- plasma superstorm
- hyper electrical storm

---

# Multiplayer Design

Players coexist within the same weather ecosystem.

Storms compete for:
- heat
- humidity
- atmospheric territory
- instability zones

Large storms may absorb or weaken smaller storms.

Environmental conditions change dynamically during matches.

---

# Map Design

Maps should contain:
- cities
- forests
- oceans
- mountains
- plains
- deserts

Different terrain affects storm growth.

Examples:
- oceans generate humidity
- cities generate heat
- mountains create lift
- deserts create instability

---

# Destruction Philosophy

See [DestructionSystem.md](DestructionSystem.md) — ships **after** storm slice, **before** agency.

Storm players destroy **mini towns and cities** by **routing** mature storms through them (wind, hail, flood, lightning along the path). No separate attack button.

Early storms barely scratch settlements. Late modes (bow, hail core, tornado) should feel catastrophic on a direct hit.

The player should feel: grow the right cell → **steer through targets** → earn destruction score.

---

# Visual Style

See [ArtDirection.md](ArtDirection.md).

Semi-realistic **storm cells** and radar-readable structures; **3D volumetric clouds** after the 2D storm slice. Gameplay clarity is more important than photorealism, but the game should **not** read as an arcade .io clone.

---

# Audio Design

Audio should evolve with storm intensity.

Examples:
- soft wind
- rainfall
- thunder
- hail
- violent tornado roar

Storms should sound increasingly dangerous as they evolve.

---

# Technical Goals

Engine:
- Godot 4

Language:
- GDScript

Architecture Goals:
- modular systems
- scalable multiplayer support
- data-driven storm stats
- reusable components
- optimized particle systems

---

# Early Prototype Goals

Prototype 1:
- moisture movement
- heat absorption
- humidity collection
- basic evolution

Prototype 2:
- cloud formation
- rainfall
- lightning
- storm scaling

Prototype 3:
- specialization paths
- destruction systems
- multiplayer testing

---

# Long-Term Vision

The final experience should feel like:
- a living weather ecosystem
- a multiplayer storm evolution sandbox
- a semi-realistic atmospheric simulation
- an emergent disaster game

The player should feel like they are controlling the evolution of nature itself.