# Controls Design

**Target controls:** [StormSimulationVision.md](StormSimulationVision.md)  
**Implementation:** [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md) — S2, S8, S9

---

# Philosophy

Controls should feel:
- **deliberate** and **meteorological** (routing a storm, not driving a ship)
- readable at map scale
- scalable to 3D chase camera (S12)

Movement should feel **heavy, slow, and constrained by wind** — not twitch arcade.

---

# Legacy Prototype (being retired)

| Input | Status |
|-------|--------|
| WASD movement | **Legacy** — debug only after S2 |
| Fast acceleration (~280 px/s) | **Legacy** — replaced by trajectory speeds |

---

# Storm Controls (target)

## Trajectory planning (primary — S2)

- **Click + drag** on map to set movement path (waypoints / polyline)
- **Release** to commit; storm follows at realistic speed
- **Replan** on cooldown (organization penalty for sharp turns)
- Actual motion blends **planned path** with **environmental wind** and **cold-pool push**

## Tactical radar (S8b)

See [StormTacticalRadar.md](StormTacticalRadar.md).

| Input | Action |
|-------|--------|
| **M** | Toggle **expanded zone** weather map (TV-style radar + 10‑min nowcast loop) |
| **Esc** | Close expanded radar |
| Minimap (bottom-right) | Always visible in play; shows all storms; auto-loops forecast |

Use radar to decide whether to **stay on course** or **replan** path.

## Camera (S8)

| Input | Action |
|-------|--------|
| Edge scroll / MMB drag | Pan detached camera |
| Scroll wheel | Zoom |
| Snap key (e.g. Space / Home) | Return to player storm |
| Hover storm | Stat panel |

**Note:** **M** = tactical map, not camera. Rebind in accessibility if needed.

## Day planning (S9 + M1–M5)

- **CONUS briefing:** pan/zoom 2.5D U.S. map, read general outlook
- **Overlay tabs:** CAPE, CIN, Td, PW, shear, SRH, lift, severe composite
- **Click zone** (1 of 10) → zoom → zone outlook
- **Pick spawn** from random weighted candidates in zone
- Confirm → **00:00** day start ([DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md))
- **On death:** respawn picker — new random candidates in **same zone** only; pick one to continue the day

---

# Storm Abilities (future / mode-gated)

Not arcade buttons on cooldown — emergent from structure:

- Hail swath from hail core
- Gust front / bow acceleration from line mode
- Tornado from mesocyclone threshold

---

# Agency Controls — DEFERRED

Weather Service / radar / warnings — see [WeatherAgencyDesign.md](WeatherAgencyDesign.md).  
**No implementation** until storm slice complete.

---

# Supported Input Types

- keyboard and mouse (primary for trajectory + camera)
- controller — map later after mouse path works
- mobile — not planned for storm path drawing v1

---

# Accessibility Goals

- Rebind snap-back, overlay toggles, replan key
- Adjustable camera speed and zoom limits
- Tooltip jargon explanations on hover stats
