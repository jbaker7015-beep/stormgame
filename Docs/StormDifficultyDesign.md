# Storm Difficulty Design

**Player-facing summary:** [StormPlayerCheatSheet.md](StormPlayerCheatSheet.md) — “Difficulty” section  
**Science terms:** [StormMeteorologyReference.md](StormMeteorologyReference.md)  
**Implementation:** Tune via `Systems/Config/` resources (e.g. `difficulty_config.gd` / `PrototypeBalance` extensions) — **S1+**

---

## Philosophy

Difficulty is **not** only faster AI or cheat buffs.

| Layer | What changes |
|-------|----------------|
| **Atmosphere** | How much CAPE, moisture, shear, SRH exists; how fast fields **recover** after depletion |
| **Thresholds** | How much you need to reach pulse / supercell / bow / tornado |
| **Forgiveness** | Entrainment, CIN, organization decay, replan penalties |
| **Cooperation** | Whether solo play can reach top modes vs needing **merges** / line-building |
| **AI** | Forecast reading and path quality (separate from ingredient generosity) |

**Easy** uses **less** of each ingredient (lower bars) and **more** supply on the map.  
**Extreme** needs **near-perfect** routing, conditions, and often **other storm cells** to hit the strongest structures.

---

## Difficulty tiers

| Tier | Audience | Storm fantasy |
|------|----------|----------------|
| **Easy** | Learning terms and controls | “I can grow a impressive supercell without expert routing.” |
| **Normal** | Default campaign / match | “I need the four ingredients and a sensible path.” |
| **Hard** | Experienced | “Depletion and dry air punish mistakes; lines need setup.” |
| **Extreme** | Mastery | “Only near-perfect paths and timing; top modes need cooperation.” |

---

## Global multipliers (design defaults)

Apply as `difficulty_multiplier` on config unless noted. **Tune in playtests.**

| Parameter | Easy | Normal | Hard | Extreme |
|-----------|------|--------|------|---------|
| `cape_map_scale` | 1.25 | 1.0 | 0.90 | 0.80 |
| `moisture_map_scale` (Td/PW bias) | 1.20 | 1.0 | 0.95 | 0.90 |
| `shear_map_scale` | 1.15 | 1.0 | 1.0 | 1.0 |
| `srh_map_scale` | 1.15 | 1.0 | 1.0 | 1.0 |
| `cin_cap_scale` (lower = weaker cap) | 0.70 | 1.0 | 1.15 | 1.30 |
| `field_recovery_rate` | 1.30 | 1.0 | 0.85 | 0.70 |
| `depletion_per_pass` | 0.75 | 1.0 | 1.15 | 1.30 |
| `entrainment_penalty` | 0.60 | 1.0 | 1.25 | 1.50 |
| `organization_decay` | 0.70 | 1.0 | 1.20 | 1.40 |
| `replan_organization_cost` | 0.50 | 1.0 | 1.25 | 1.50 |

**Reading the table:** Easy = **more** CAPE/moisture on map, **weaker** cap, **slower** depletion, **less** dry-air death. Extreme = opposite.

---

## Mode thresholds (example — J/kg, m/s, m²/s²)

Multiply required thresholds by `threshold_multiplier`:

| Tier | `threshold_multiplier` |
|------|------------------------|
| Easy | 0.65 |
| Normal | 1.0 |
| Hard | 1.15 |
| Extreme | 1.35 |

### Supercell gate (illustrative baselines @ Normal)

Reference science: ~15–20 m/s **bulk shear 0–6 km** in many supercell environments ([ESTOFEX / operational guides](https://www.estofex.org/guide/1_4_4.html)).

| Requirement | Normal baseline (tunable) | Easy (×0.65) | Extreme (×1.35) |
|-------------|---------------------------|--------------|-----------------|
| CAPE min | 1500 J/kg | ~975 | ~2025 |
| Bulk shear 0–6 km | 15 m/s | ~10 | ~20 |
| SRH 0–1 km | 100 m²/s² | ~65 | ~135 |
| Min organization | 40 | ~26 | ~54 |
| Sustained time in favorable air | 90 s | ~60 s | ~120 s |

### Bow echo / strong QLCS (illustrative)

| Requirement | Normal | Easy | Extreme |
|-------------|--------|------|---------|
| Line length (cells merged) | 2+ | 1+ (forgiving) | 3+ |
| Cold-pool strength | 50 | 35 | 65 |
| Parallel motion alignment | moderate | loose | strict |
| **Requires merge** | optional | no | **yes** |

### Tornado (illustrative)

| Requirement | Normal | Easy | Extreme |
|-------------|--------|------|---------|
| Mesocyclone score | 60 | 45 | 75 |
| SRH 0–1 km | 150 m²/s² | ~100 | ~200 |
| LCL tier | any low/med | high LCL OK | low LCL required |
| Solo allowed | yes | yes | disfavored (need supercell health + timing) |

---

## Cooperation requirements by tier

| Mode | Easy | Normal | Hard | Extreme |
|------|------|--------|------|---------|
| Solo supercell | Common | Expected | Harder | Rare without perfect map |
| Solo mature hail core | Common | Expected | Hard | Very hard |
| Squall line / QLCS | Optional merge | Merge helps | Merge often needed | **Required** for reliable line |
| Bow echo | Can spawn from strong solo line | Merge + motion | Merge + cold pool sync | **Required** + sustained bow path |
| Max destruction run (D phase) | Forgiving town HP | Normal | Tough structures | Urban resistance high |

**Implementation hook:** `require_merged_cells_for_mode: Array[StormMode]` per difficulty in config.

---

## AI scaling (separate from ingredients)

AI should not cheat CAPE on Extreme; it should **use** the atmosphere better.

| Tier | AI behavior |
|------|-------------|
| Easy | Slow replan, ignores some boundaries, tolerates dry routes |
| Normal | Seeks CAPE + Td, basic boundary following |
| Hard | Reads depletion, avoids entrainment, contests merges |
| Extreme | Near-optimal paths, merge timing, targets player depletion zones |

See [AISystemsDesign.md](AISystemsDesign.md) — update when S11 ships.

---

## UI / briefing

- Show **difficulty badge** on briefing screen.  
- Optional **“why you failed”** on death: entrainment, cap, depletion, insufficient shear — teaches science.  
- Extreme: show **ingredient checklist** with live pass/fail (educational, from cheat sheet).

---

## Implementation checklist

- [ ] `DifficultyConfig` resource with tables above  
- [ ] `AtmosphereGrid.apply_difficulty()` on day seed  
- [ ] `StormModeEvaluator` uses `threshold_multiplier`  
- [ ] `StormInteraction` merge rules use `require_merged_cells_for_mode`  
- [ ] In-game link: **Help → Cheat Sheet** → `StormPlayerCheatSheet.md` content  

---

## Document history

| Date | Note |
|------|------|
| 2026-05 | Easy = more ingredients / lower bars; Extreme = perfect routing + cooperation |
