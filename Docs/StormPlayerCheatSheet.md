# Storm Player Cheat Sheet

**For learning while you play.** Real forecast terms are used on purpose — this sheet explains them in plain language.

**Deep dive (sources & units):** [StormMeteorologyReference.md](StormMeteorologyReference.md)  
**How Easy / Hard changes numbers:** [StormDifficultyDesign.md](StormDifficultyDesign.md)

---

## The four things every storm needs

Think of these as **MILS** — **M**oisture, **I**nstability, **L**ift, **S**hear.

| Ingredient | On your map / HUD | Plain English |
|------------|-------------------|---------------|
| **Moisture** | **Td** (dewpoint), **PW** (precipitable water) | Is there enough humid air to build clouds and rain? Dry air kills storms. |
| **Instability** | **CAPE**, **CIN** (cap) | **CAPE** = fuel for rising air. **CIN** = a lid; you need **lift** or heating to break it. |
| **Lift** | Fronts, **dryline**, **outflow boundary**, hills | Something has to **trigger** the air to rise. High CAPE under a strong cap does nothing. |
| **Shear** | **Bulk shear (0–6 km)**, **SRH** | Wind changing with height **tilts** the storm and can spin it. Weak shear = short pulse storms. |

**Rule of thumb:** You need **all four** for a **supercell**. High CAPE alone is not enough.

---

## Words you will see on the briefing map

| Term | Remember this |
|------|----------------|
| **CAPE** | Updraft fuel (J/kg). Higher = stronger towers possible. |
| **CIN** | The **cap**. Big negative CIN = hard to start without a boundary. |
| **Td** | Dewpoint — surface moisture. Higher = healthier storms. |
| **PW** | Water in the whole column — heavy rain / flooding potential. |
| **LCL** | **Cloud base** height. Lower often means a more “tornado-visible” setup. |
| **Bulk shear** | Wind change 0–6 km. Enough shear helps **supercells** form. |
| **SRH** | Spin ingredient (0–1 km). High SRH + strong updraft → **mesocyclone** risk. |
| **Steering wind** | Which way the atmosphere **pushes** you — your path blends with this. |

---

## Match flow (U.S. map)

1. **CONUS briefing** — 2.5D U.S. map, **general outlook**, click **overlay tabs** (CAPE, Td, shear, …).  
2. **Pick a zone** (1 of 10 climates) — map **zooms in**; read **zone outlook** for today. **Season** changes what’s possible.  
3. **Pick a spawn** — several **random** starts weighted by weather; choose one.  
4. **00:00–24:00** — one storm (more via skill tree later); maximize **damage $** by day end.  
5. **Recap** — leaderboard of **dollars** destroyed per player/AI storm.

**Multiplayer briefing:** Each zone shows **Storm 👤/🤖** and **Agency 👤/🤖** — how many humans and AI picked that zone. Use this to find empty zones or chase PvP.

Details: [USMapAndZonesDesign.md](USMapAndZonesDesign.md), [DayCycleAndRecapDesign.md](DayCycleAndRecapDesign.md), [BriefingZoneOccupancy.md](BriefingZoneOccupancy.md).

---

## How you actually play (storm movement)

1. **Read the day** — overlays for CAPE, Td, shear, boundaries (CONUS or zone zoom).  
2. **Pick a start** near moisture + lift, not the prettiest empty field.  
3. **Draw a path** (click-drag) — you choose **intent**; the atmosphere chooses **speed and drift**.  
4. **Gather along the route** — you **use up** CAPE and moisture; other storms do too.  
5. **Grow the right shape** — supercell vs squall line needs different routes and shear.  
6. **Route through towns** (later) — mature modes do damage; weak cells barely scratch them.

**You are not a spaceship.** You cannot instantly turn or ignore the wind.

---

## Storm shapes (what you are trying to become)

| Type | What it looks like | What you need (simple) |
|------|--------------------|-------------------------|
| **Pulse** | Small, short-lived | Some CAPE + moisture; shear weak OK |
| **Multicell** | Blobby cluster | Decent ingredients; messy path OK |
| **Supercell** | Rotating, persistent | **Shear + SRH + CAPE + moisture + lift** |
| **Squall line / QLCS** | Long line of storms | Merge with other cells; parallel motion |
| **Bow echo** | Radar “bow” bulge | Strong line + cold pool; **severe straight-line wind** |
| **Hail core** | Bright radar core aloft | Strong updraft + time in the core |
| **Tornado** | Hook + wall cloud / funnel | **Mesocyclone** + strong **SRH** + sustained health |

**Hook echo** = rotation wrapping rain (danger). **Bow echo** = wind machine on a line.

---

## Lightning (what you see vs what hurts)

| Type | Name | Effect |
|------|------|--------|
| **IC** | Intracloud | Branches inside the cloud — scary sky, no ground hit |
| **CG** | Cloud-to-ground | **Return stroke** — damage, fires, thunder **after** a delay |

Thunder arrives about **3 seconds per kilometer** (5 seconds per mile) after a **CG** strike — farther = longer wait.

---

## Good routes vs bad routes

### Good signs
- Moving along a **dryline** or **front** into **higher Td** and **CAPE**
- Staying in **SRH** and **shear** while updraft is strong
- Riding an **outflow boundary** for new lift (without getting choked by cold air)
- On **Hard+**, **merging** with another cell to build a **line** or **MCS**

### Bad signs (storm weakens / dies)
- Plunging into **dry air** (**entrainment**) — low Td west of dryline
- **High CIN** with no **lift** — cap never breaks
- **Depleted** zones — someone already ate the CAPE
- Sharp turns that wreck **organization** (storm health)

**Death** = organization gone → **pick another spawn** in your **original zone** (new random points); the map remembers depletion; clock keeps going.

---

## Cooperation with other storms

Storms are not always enemies.

| Situation | Result |
|-----------|--------|
| Parallel motion + close cells | Can build a **squall line** / **MCS** |
| Compatible inflow | Shared **moisture feed**, stronger line |
| Dominant **cold pool** | Can **undercut** you — avoid wrong side of outflow |
| **Hard / Extreme** | Often **need** a merge or coordinated line for **bow**-level wind |

On **Easy**, you can still get strong storms solo. On **Extreme**, perfect solo supercells are rare — **timing a merge** matters.

---

## Tactical radar (TV map)

| UI | Tip |
|----|-----|
| **Bottom-right minimap** | Radar loop = **next 10 minutes** if everyone stays on current path |
| **M** | Big **zone map** — same loop, **all player + AI storms** |
| Use it | Bad loop? **Replan**. Good loop into towns? **Stay the course** |

---

## Camera & inspection

| Action | Tip |
|--------|-----|
| Pan / zoom | Scout boundaries and other storms |
| **Snap back** | Return to your cell instantly |
| **Hover** a storm | Full stats: CAPE uptake, SRH, mode, hail, health |

---

## Difficulty — what changes (not just “smarter AI”)

Same real terms on screen; **how much** you need changes.

| Mode | Ingredients & storms | Routing & cooperation |
|------|------------------------|------------------------|
| **Easy** | Lower CAPE/shear/SRH needed; cap breaks easier; more moisture on map | Forgiving path; weak storms survive mistakes; strong storms easier solo |
| **Normal** | Balanced “training” defaults | Must respect four ingredients; some depletion |
| **Hard** | Stricter thresholds; faster depletion; drier slots hurt more | Near-good routes required; **merges** help for lines and bows |
| **Extreme** | Realistic-style thresholds; harsh entrainment; scarce high-CAPE axes | **Near-perfect** path, timing, and often **multi-cell cooperation** for top modes |

**Easy** = learn vocabulary and shapes. **Extreme** = earn the hook echo.

Full multiplier tables: [StormDifficultyDesign.md](StormDifficultyDesign.md).

---

## One-page checklist before you draw a path

- [ ] Is there **moisture** (Td / PW) where I am going?  
- [ ] Is there **CAPE** left there, or already eaten?  
- [ ] Can I break the **cap** (CIN) with a **boundary** or heating?  
- [ ] Is **shear / SRH** enough for the mode I want?  
- [ ] Does **steering wind** help or fight my line?  
- [ ] On Hard+, do I need another cell to form a **line** or **bow**?  
- [ ] Am I about to dive into **dry air**?

---

## Where to learn more

- In-game tooltips use the same names as this sheet.  
- Design reference for developers: [StormMeteorologyReference.md](StormMeteorologyReference.md)  
- Vision & modes: [StormSimulationVision.md](StormSimulationVision.md)

*StormGame educates with real meteorology — gameplay simplifies the physics, not the vocabulary.*
