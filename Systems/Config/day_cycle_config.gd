extends Node

## One match day = 00:00–24:00 game time. See Docs/DayCycleAndRecapDesign.md.

const GAME_HOURS_PER_DAY: float = 24.0
const REAL_SECONDS_PER_GAME_HOUR: float = 120.0  # 48 real minutes per full day
