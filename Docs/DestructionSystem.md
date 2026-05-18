# Destruction System

**Schedule:** After storm implementation (**S0–S12**), **before** Weather Service / agency.  
**Implementation:** [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md) — **D1–D5**  
**Storm routing vision:** [StormSimulationVision.md](StormSimulationVision.md)  
**Recap & clock:** [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md)

---

# Philosophy

Destruction is the **payoff for correct storm growth and routing**.

Storm players:
1. Read the daily atmosphere and grow a credible cell (supercell, squall line, etc.).
2. **Plan a path** across the map through **mini towns and cities**.
3. Cause damage with **wind, hail, flood, and lightning** as the storm passes — not with arcade abilities.

Destruction should:
- feel **earned** (weak storms barely harm; mature modes are catastrophic)
- scale with **storm mode and organization**
- reward **strategic routing**, not random wandering
- stay **readable** (clear before/after on settlements)

Early storms should feel weak over towns. A **bow echo through a city** should feel terrifying.

---

# Settlements on the Map (D1)

The playable map contains scattered **settlements**, not a fully simulated building engine for every house on Earth.

| Type | Role | Typical size |
|------|------|----------------|
| **Hamlet / mini town** | Many small targets; practice routing | Few blocks, low score |
| **Town** | Mid objectives; hail/wind swaths matter | Suburban footprint |
| **City** | High-value targets; heat island optional | Larger polygon, more structures |

### Placement rules

- Clusters along **rivers, plains, coasts, highways** — readable from map zoom.
- **Gaps** between settlements so storms travel through **open country** (ingredient gathering) **and** **built-up corridors** (destruction).
- Cities are **rare**; mini towns are **common**.
- Settlements are **targets**, not collision walls — storms pass through.

### Hover / UI

- Name, type, population tier, current damage %, resistance summary.

---

# Route-Driven Damage (D2)

Damage applies when the **storm footprint** overlaps settlement geometry during movement.

| Source | Storm condition | Effect |
|--------|-----------------|--------|
| **Wind** | Gust front, bow, line, tornado tier | Structural damage, trees, power lines |
| **Hail** | Hail core / strong updraft path | Roofs, vehicles, crops |
| **Flood** | Training rain, slow movement over town | Road water, basement tier (simplified) |
| **Lightning** | CG strikes in footprint | Fires, outages (lightweight) |

### Gating

- **Pulse / weak cell** — minor damage only.
- **Supercell hail core** — severe swath, narrow and intense.
- **Bow echo** — extreme straight-line wind strip.
- **Tornado** — localized max damage in funnel path.

No damage button — if the route misses the town, **score stays low**.

---

# Structural Model (simplified)

Buildings / districts use aggregates, not per-mesh physics:

- **Health** per district or building cluster
- **Resistance:** wind, hail, flood, lightning (material tier)
- **Infrastructure** subset in cities: hospital, grid, comms — higher resistance, higher score if destroyed (balance TBD)

States: **Intact → Damaged → Destroyed** (sprite or tint change).

---

# Debris & Feedback (D3)

- Limited debris particles; optional tornado lofting
- Local one-shots (hail on metal, collapse) from recorded audio ([AudioDesign.md](AudioDesign.md))
- **Day-persistent** damage overlay on map (ruined % visible until day ends)

Performance: prioritize readability; no full rigid-body city sim.

---

# Scoring — damage in U.S. dollars ($)

**Primary outcome:** total **property damage $** per storm at **24:00** recap ([DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md)).

| Hazard | Typical $ sources |
|--------|-------------------|
| Wind | Structures, trees, power |
| Hail | Roofs, vehicles, crops |
| Flood | Buildings, roads |
| Lightning | Fire, electrical |

Hamlet &lt; town &lt; city $ multipliers. Cities include higher-value infrastructure (more $, more resistance).

**AI storms** appear on the same recap leaderboard.

---

# In-day objectives (D4)

Optional mid-day goals (tunable):

- First **$100M** damage
- Hit **N** cities across zones
- Max **$** from a single bow-echo pass

Running tally on HUD; full breakdown on recap (D5).

---

# Relationship to Other Systems

| System | Link |
|--------|------|
| **Atmosphere grid (S1)** | Routing still needs CAPE/moisture; towns don’t replace ingredients |
| **Storm modes (S4)** | Mode determines damage profile |
| **Agency (deferred)** | Later: warnings, evacuations, harden infrastructure **against** this damage model |
| **Population sim** | Optional detail after D2; not required for first destruction slice |

---

# Out of Scope (First Destruction Slice)

- Full interior building gameplay
- Realistic insurance / economy sim
- Agency counterplay (comes **after** D4)
- Multiplayer destruction sync (after solo D slice)

---

# Success Criteria (Destruction Vertical Slice)

- [ ] Map shows mini towns and cities.  
- [ ] Routing a mature storm through a town causes visible, mode-appropriate damage.  
- [ ] Weak storm / bad path = negligible destruction.  
- [ ] End-of-day **$ recap** ranks player and AI storms.  
- [ ] AI can damage towns under same rules.  

---

# Document History

| Date | Note |
|------|------|
| 2026-05 | Route-driven destruction; settlements; ordered after S12, before agency |
