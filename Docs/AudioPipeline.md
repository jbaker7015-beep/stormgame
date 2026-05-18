# Storm Audio Pipeline (Recorded, High Quality)

**Goal:** Documentary-real wind, rain, hail, thunder — replace procedural buzz for release.  
**Phase:** **S7** (procedural `storm_audio_synth.gd` remains **dev fallback**)

---

## Layer model

| Bus | Content | Behavior |
|-----|---------|----------|
| **Ambience** | Wind bed by intensity tier | Loop crossfade |
| **Rain** | Light / med / heavy stems | Crossfade by storm rain rate |
| **Hail** | Impacts + swarm on roof | One-shots when in hail core |
| **Thunder** | Near / far samples | CG-triggered; delay by distance |
| **UI** | Briefing, recap | Quiet |

---

## Sourcing audio (legal)

| Source type | Notes |
|-------------|--------|
| **Commercial libraries** | BOOM Library Weather, Sound Ideas Nature, Pro Sound Effects — best for shipping |
| **Sonniss GDC bundles** | Large royalty-free sets; check license per pack |
| **Field recordists** | Custom pack buyout for unique identity |
| **Freesound / CC** | Attribution or CC0 only; avoid NC for commercial |

Maintain `Audio/LICENSES.md` with pack name, license, date.

---

## Required asset list (minimum)

| Asset | Variants |
|-------|----------|
| Wind loop | 4 intensities × 2 variants |
| Rain loop | light, moderate, heavy, torrent |
| Hail | single impacts + loop bed |
| Thunder crack | 6+ near |
| Thunder rumble tail | 6+ far |
| Distant thunder bed | optional |

Format: **`.ogg` Vorbis** for loops; short one-shots `.wav` ok.

---

## Godot implementation (S7)

1. **No shared streams** — `duplicate()` per player or load per instance.  
2. **Audio buses:** `Master / Storm / Ambience / Thunder`  
3. `StormAudioManager` reads storm stats + camera distance.  
4. **CG strike:** play crack → schedule rumble with `delay = distance_m / 343.0`  
5. **3D optional:** `AudioStreamPlayer2D` at strike position for gameplay map.  
6. `DEBUG_PROCEDURAL_AUDIO=true` in debug builds only.

---

## Mix targets

- Wind + rain never clip; sidechain duck ambience under thunder.  
- Hail only when `hail_tier > 0`.  
- Briefing: soft wind bed only.

---

## Workflow for you (non-audio expert)

1. Buy or download one **starter storm pack** (~$50–200) with rain/wind/thunder.  
2. Drop into `Audio/Weather/` with consistent names.  
3. Run import defaults in Godot (Ogg, loop mode on loops).  
4. We wire intensity in S7.

Until then: keep current synth; flag in UI as “placeholder audio”.

---

## Document history

| Date | Note |
|------|------|
| 2026-05 | Recorded audio pipeline for S7 |
