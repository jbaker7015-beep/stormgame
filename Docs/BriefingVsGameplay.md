# Briefing vs Gameplay — Two Different Screens

**Why the playtest looks wrong:** You are still in the **legacy gameplay scene** (`prototype_world.tscn`) with **S1 dev tools** layered on top. That is expected until **S9 + M2** ship.

---

## Do we strip out existing gameplay?

**No — we do not throw away the storm prototype.**

| Keep (evolve) | Remove / retire later |
|---------------|------------------------|
| Storm entity, stats, evolution, AI | **WASD** arcade movement (S2) |
| Weather FX, audio | Colored **debug grid** on gameplay screen |
| HUD stats (move to cleaner layout) | Old **biome circles** as primary map (replaced by zones + art) |
| Play world camera | Top-left clutter once briefing HUD exists |

**Flow:**

```text
Main menu → BRIEFING SCENE (new) → press Ready → GAMEPLAY SCENE (current world, upgraded)
```

Briefing is a **separate scene or GameManager state**, not the live play view.

---

## What belongs where

### Briefing window / scene (M2, M3, M4, M5, S9)

**Before** the day starts (**00:00**). Player is **not** moving a storm yet.

| Element | Here? |
|---------|--------|
| **CONUS-shaped U.S. map** (2.5D terrain, roads, cities) | **Yes** |
| General weather **outlook** text | **Yes** |
| Ingredient **overlay tabs** (CAPE, Td, shear, SRH, …) | **Yes** |
| Click **zone** → zoom → zone outlook | **Yes** |
| Pick **spawn** | **Yes** |
| Multiplayer **zone occupancy** (👤/🤖) | **Yes** |
| Unlimited until **Ready** | **Yes** |

This is what should look like “TV / forecast office” planning — **not** the hexagon playfield.

### Gameplay scene (current prototype + future)

**After** Ready. Storm moves, time runs, damage happens.

| Element | Here? |
|---------|--------|
| Storm movement (path drawing S2) | **Yes** |
| Chase camera / world view | **Yes** |
| Compact **stats HUD** (corner, minimal) | **Yes** |
| **Tactical radar** minimap bottom-right (S8b) | **Yes** — **10-min loop**, not full CAPE briefing |
| **M** expanded **zone** radar | **Yes** |
| Full-screen CAPE heatmap grid | **No** (briefing only) |
| CONUS briefing map | **No** |

### S1 dev overlay (temporary)

`AtmosphereOverlay` on `prototype_world` with keys **1–4** is a **programmer test** of the atmosphere grid. It is **not** the final player UX. Default is **off** in play; use only to verify S1 data until briefing UI exists.

---

## What you saw in the screenshot

| On screen | What it is |
|-----------|------------|
| Colored square grid | S1 **CAPE overlay** (dev; was default ON) |
| Faint circles | Legacy **biome zones** (Ocean, Urban Heat, …) |
| Hexagon storm + AI Beta/Gamma | **Prototype storms** (S10 replaces art) |
| Top-left text panel | **Prototype HUD** — stays in gameplay, layout TBD |
| No U.S. silhouette | **M2 map art not built yet** — still abstract rectangle |

---

## Build order reminder

1. **S1** — grid data (done, dev overlay optional)  
2. **S2** — path movement  
3. **M2** — real CONUS art  
4. **M3–M5 + S9** — **briefing scene** (U.S. map + overlays + spawn)  
5. **S8b** — bottom-right tactical radar **during** play  

---

## Document history

| Date | Note |
|------|------|
| 2026-05 | Clarify briefing scene vs gameplay; do not strip prototype |
