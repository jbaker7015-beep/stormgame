# Player Progression & Skill Tree

**Status:** **Deferred implementation** — design now so systems don’t block it later.  
**Ships after:** Storm slice + destruction recap ([StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md) — **P1+**).  
**Related:** [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md), [StormDifficultyDesign.md](StormDifficultyDesign.md)

---

## Philosophy

Progression rewards **learning real meteorology and routing**, not raw stat inflation.

- **XP** from end-of-day **damage dollars**, mode milestones, and daily objectives.  
- **Skill tree** branches modify **how** you play — not “+50% arbitrary damage.”  
- Early game: **one storm**, basic overlays. Veterans: optional complexity unlocked.

---

## Player levels

| Level band | Unlocks (examples) |
|------------|-------------------|
| 1–5 | Base briefing overlays (CAPE, Td, Shear) |
| 6–10 | SRH, CIN, PW cuts; spawn reroll once per day |
| 11–15 | Zone outlook “risk ribbon” hints (educational, subtle) |
| 16–20 | Faster replan cooldown; organization decay −5% |
| 21+ | Prestige cosmetics, ranked queue |

Exact XP curve in `ProgressionConfig` — tune from recap data.

---

## Skill tree branches (draft)

Player spends **skill points** (1 per level or per milestone).

### 1. Forecaster (briefing & intel)

- Extra overlay blend (two cuts at once)  
- Zone outlook +1 sentence detail  
- See AI spawn zones faintly on Hard+ (balance risk)  
- **Capstone:** 1 free spawn reroll showing 3 extra candidates

### 2. Storm navigator (movement & survival)

- −10% replan organization penalty  
- +5% storm motion vs steering wind (still realistic cap)  
- Wider “favorable air” detection on HUD  
- **Capstone:** **Second simultaneous storm** (user-requested late unlock) OR child cell that inherits 50% stats (design pick at P1)

### 3. Severe modes (meteorology gates)

- −5% CAPE threshold for supercell (Normal difficulty only)  
- Slightly wider hail core footprint  
- Bow echo wind damage +8% (destruction phase)  
- **Capstone:** Once per day “mesocyclone surge” if SRH gate met

### 4. Destruction economy (D phase)

- +5% damage $ in towns (not cities) — early filler  
- Hail $ multiplier +10%  
- **Capstone:** End recap shows “optimal path” ghost vs your path

### 5. Ecosystem (multiplayer future)

- Merge assistance hint when line-forming  
- Reduced ingredient depletion in your wake (−8%) — controversial, rank-only off

**Rule:** No skill removes need for **lift, moisture, shear, or CAPE** on Extreme.

---

## Multiple storms unlock

| Unlock | Requirement | Behavior |
|--------|-------------|----------|
| **Twin cell** | Forecaster 5 + Navigator capstone | Two storms, shared organization pool OR independent weak second |
| **Split supercell** | Severe 5 | One-time split on supercell upgrade; cooldown 6 game hours |

Default match: **one active storm** until unlocked.

---

## Monetization note

Cosmetics only in [Monetization.md](Monetization.md) — **no pay-to-win** CAPE on Extreme.

---

## Implementation phases (P)

| Phase | Delivers |
|-------|----------|
| **P1** | XP from D5 recap; level number in profile |
| **P2** | Skill tree UI + 1 branch (Navigator) |
| **P3** | Full branches + twin storm capstone |
| **P4** | Ranked seasons + persistence |

**Do not start P1** until **D5** recap ships.

---

## Document history

| Date | Note |
|------|------|
| 2026-05 | Initial skill tree; multi-storm deferred to progression |
