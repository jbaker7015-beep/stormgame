extends Node

## Procedural storm audio — player progression plus rival storms by distance and strength.

const WeatherFx = preload("res://Scripts/Weather/storm_weather_effects.gd")

@onready var _wind_player: AudioStreamPlayer = $WindPlayer
@onready var _rain_player: AudioStreamPlayer = $RainPlayer
@onready var _hum_player: AudioStreamPlayer = $HumPlayer
@onready var _thunder_player: AudioStreamPlayer = $ThunderPlayer
@onready var _ai_wind_player: AudioStreamPlayer = $AIWindPlayer
@onready var _ai_rain_player: AudioStreamPlayer = $AIRainPlayer
@onready var _ai_hum_player: AudioStreamPlayer = $AIHumPlayer
@onready var _ai_thunder_player: AudioStreamPlayer = $AIThunderPlayer

var _wind_playback: AudioStreamGeneratorPlayback
var _rain_playback: AudioStreamGeneratorPlayback
var _hum_playback: AudioStreamGeneratorPlayback
var _ai_wind_playback: AudioStreamGeneratorPlayback
var _ai_rain_playback: AudioStreamGeneratorPlayback
var _ai_hum_playback: AudioStreamGeneratorPlayback

var _wind_volume: float = 0.0
var _rain_volume: float = 0.0
var _hum_volume: float = 0.0
var _ai_wind_volume: float = 0.0
var _ai_rain_volume: float = 0.0
var _ai_hum_volume: float = 0.0
var _ai_stereo_pan: float = 0.0

var _noise_state: float = 0.0
var _ai_noise_state: float = 0.35


func _ready() -> void:
	_wind_playback = _start_generator(_wind_player)
	_rain_playback = _start_generator(_rain_player)
	_hum_playback = _start_generator(_hum_player)
	_ai_wind_playback = _start_generator(_ai_wind_player)
	_ai_rain_playback = _start_generator(_ai_rain_player)
	_ai_hum_playback = _start_generator(_ai_hum_player)
	_wind_volume = PrototypeBalance.AUDIO_WIND_IDLE
	GameManager.player_registered.connect(_on_player_registered)


func _physics_process(_delta: float) -> void:
	_sync_player_atmosphere()
	_sync_ai_storm_audio()


func _process(_delta: float) -> void:
	_fill_generator(_wind_playback, _wind_volume, 0.4, false, 0.0, true)
	_fill_generator(_rain_playback, _rain_volume, 0.85, false, 0.0, true)
	_fill_generator(_hum_playback, _hum_volume, 0.08, true, 0.0, true)
	_fill_generator(_ai_wind_playback, _ai_wind_volume, 0.38, false, _ai_stereo_pan, false)
	_fill_generator(_ai_rain_playback, _ai_rain_volume, 0.82, false, _ai_stereo_pan, false)
	_fill_generator(_ai_hum_playback, _ai_hum_volume, 0.07, true, _ai_stereo_pan, false)


func _on_player_registered(_player: Node2D) -> void:
	_sync_player_atmosphere()


func _sync_player_atmosphere() -> void:
	var stats: MoisturePocketStats = GameManager.get_player_stats() as MoisturePocketStats
	if stats == null:
		_wind_volume = PrototypeBalance.AUDIO_WIND_IDLE
		_rain_volume = 0.0
		_hum_volume = PrototypeBalance.AUDIO_HUM_IDLE
		return

	var rain: float = WeatherFx.compute_rain_intensity(stats, false)
	var storm: float = WeatherFx.compute_storm_intensity(stats)
	var stage: int = int(stats.get_growth_stage())
	_apply_player_volumes(rain, storm, stage)


func _sync_ai_storm_audio() -> void:
	var player: Node2D = GameManager.player
	if player == null:
		_ai_wind_volume = 0.0
		_ai_rain_volume = 0.0
		_ai_hum_volume = 0.0
		_ai_stereo_pan = 0.0
		return

	var rain_mix: float = 0.0
	var wind_mix: float = 0.0
	var hum_mix: float = 0.0
	var pan_numerator: float = 0.0
	var pan_weight: float = 0.0
	var max_stage: int = MoisturePocketStats.GrowthStage.DEVELOPING_THUNDERSTORM

	for storm in AIManager.ai_storms:
		if not is_instance_valid(storm):
			continue

		var stats: MoisturePocketStats = storm.get_node_or_null("Stats") as MoisturePocketStats
		if stats == null:
			continue

		var distance: float = player.global_position.distance_to(storm.global_position)
		var proximity: float = _proximity_falloff(distance)
		if proximity <= 0.001:
			continue

		var rain: float = WeatherFx.compute_rain_intensity(stats, true)
		var storm_intensity: float = WeatherFx.compute_storm_intensity(stats)
		var stage_norm: float = clampf(
			float(stats.get_growth_stage()) / float(max_stage),
			0.0,
			1.0
		)
		var strength: float = clampf(
			storm_intensity * 0.58 + rain * 0.42,
			0.0,
			1.0
		) * lerpf(0.6, 1.18, stage_norm)
		var weight: float = proximity * strength

		rain_mix += rain * weight
		wind_mix += storm_intensity * weight
		hum_mix += (stage_norm * 0.5 + strength * 0.5) * weight

		var side: float = signf(storm.global_position.x - player.global_position.x)
		if absf(side) < 0.01:
			side = 0.0
		pan_numerator += side * weight
		pan_weight += weight

	rain_mix = _soft_cap_mix(rain_mix)
	wind_mix = _soft_cap_mix(wind_mix)
	hum_mix = _soft_cap_mix(hum_mix)

	_ai_rain_volume = rain_mix * PrototypeBalance.AUDIO_AI_RAIN_MAX
	_ai_wind_volume = wind_mix * PrototypeBalance.AUDIO_AI_WIND_MAX
	_ai_hum_volume = hum_mix * PrototypeBalance.AUDIO_AI_HUM_MAX
	_ai_stereo_pan = clampf(pan_numerator / maxf(pan_weight, 0.0001), -1.0, 1.0)


func _apply_player_volumes(
	rain_intensity: float,
	storm_intensity: float,
	growth_stage: int
) -> void:
	var max_stage: int = MoisturePocketStats.GrowthStage.DEVELOPING_THUNDERSTORM
	var stage_norm: float = clampf(float(growth_stage) / float(max_stage), 0.0, 1.0)
	var combined: float = clampf(
		storm_intensity * 0.55 + rain_intensity * 0.45,
		0.0,
		1.0
	)
	var stage_lift: float = lerpf(0.82, 1.38, stage_norm)

	_rain_volume = lerpf(0.0, PrototypeBalance.AUDIO_RAIN_MAX, rain_intensity) * stage_lift
	_wind_volume = lerpf(
		PrototypeBalance.AUDIO_WIND_IDLE,
		PrototypeBalance.AUDIO_WIND_MAX,
		storm_intensity
	) * lerpf(0.88, 1.28, stage_norm)
	_hum_volume = lerpf(
		PrototypeBalance.AUDIO_HUM_IDLE,
		PrototypeBalance.AUDIO_HUM_MAX,
		stage_norm
	) + combined * PrototypeBalance.AUDIO_HUM_COMBINED_BOOST


func play_thunder(intensity: float = 1.0) -> void:
	_play_thunder_on(_thunder_player, intensity, PrototypeBalance.AUDIO_THUNDER_MIN_DB, PrototypeBalance.AUDIO_THUNDER_MAX_DB)


func play_ai_thunder(intensity: float, world_position: Vector2) -> void:
	var player: Node2D = GameManager.player
	if player == null:
		return

	var distance: float = player.global_position.distance_to(world_position)
	var proximity: float = _proximity_falloff(distance)
	if proximity <= 0.02:
		return

	var audible_charge: float = clampf(intensity * proximity, 0.0, 1.0)
	var pan: float = clampf(
		(world_position.x - player.global_position.x) / PrototypeBalance.AUDIO_AI_PAN_RANGE,
		-1.0,
		1.0
	)
	_play_thunder_on(
		_ai_thunder_player,
		audible_charge,
		PrototypeBalance.AUDIO_AI_THUNDER_MIN_DB,
		PrototypeBalance.AUDIO_AI_THUNDER_MAX_DB,
		pan
	)


func _play_thunder_on(
	player: AudioStreamPlayer,
	intensity: float,
	min_db: float,
	max_db: float,
	stereo_pan: float = 0.0
) -> void:
	var charge: float = clampf(intensity, 0.0, 1.0)
	if player.playing:
		player.stop()
	player.stream = _build_thunder_stream(charge, stereo_pan)
	player.volume_db = lerpf(min_db, max_db, charge)
	player.play()


func _proximity_falloff(distance: float) -> float:
	if distance >= PrototypeBalance.AUDIO_AI_MAX_HEAR_DISTANCE:
		return 0.0
	var linear: float = inverse_lerp(
		PrototypeBalance.AUDIO_AI_MAX_HEAR_DISTANCE,
		PrototypeBalance.AUDIO_AI_FULL_HEAR_DISTANCE,
		distance
	)
	return linear * linear


func _soft_cap_mix(value: float) -> float:
	var cap: float = PrototypeBalance.AUDIO_AI_MIX_CAP
	if value <= cap:
		return value
	return cap + (value - cap) * 0.25


func _start_generator(player: AudioStreamPlayer) -> AudioStreamGeneratorPlayback:
	var stream := AudioStreamGenerator.new()
	stream.mix_rate = 22050
	stream.buffer_length = 0.12
	player.stream = stream
	player.play()
	return player.get_stream_playback() as AudioStreamGeneratorPlayback


func _fill_generator(
	playback: AudioStreamGeneratorPlayback,
	volume: float,
	noise_weight: float,
	use_tone: bool,
	stereo_pan: float,
	use_player_noise: bool
) -> void:
	if playback == null or volume <= 0.0001:
		return

	var noise_state: float = _noise_state if use_player_noise else _ai_noise_state
	var to_fill: int = playback.get_frames_available()
	for _i in to_fill:
		noise_state = fmod(noise_state + noise_weight, 1.0)
		var noise: float = (randf() * 2.0 - 1.0) * volume
		if use_tone:
			var tone: float = sin(noise_state * TAU * 2.0) * volume * 0.35
			noise = noise * 0.65 + tone

		var pan: float = clampf(stereo_pan, -1.0, 1.0)
		var left_gain: float = lerpf(1.0, 0.35, maxf(pan, 0.0))
		var right_gain: float = lerpf(1.0, 0.35, maxf(-pan, 0.0))
		playback.push_frame(Vector2(noise * left_gain, noise * right_gain))

	if use_player_noise:
		_noise_state = noise_state
	else:
		_ai_noise_state = noise_state


func _build_thunder_stream(intensity: float, stereo_pan: float = 0.0) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	stream.stereo = true

	var duration: float = lerpf(0.28, 0.62, intensity)
	var sample_count: int = int(22050.0 * duration)
	var data := PackedByteArray()
	data.resize(sample_count * 4)

	var pan: float = clampf(stereo_pan, -1.0, 1.0)
	var left_gain: float = lerpf(1.0, 0.4, maxf(pan, 0.0))
	var right_gain: float = lerpf(1.0, 0.4, maxf(-pan, 0.0))

	for i in sample_count:
		var t: float = float(i) / 22050.0
		var envelope: float = exp(-t * 6.5) * (1.0 - t / duration)
		var sample_f: float = randf_range(-1.0, 1.0) * envelope * lerpf(0.55, 1.0, intensity)
		var left_i: int = int(clampf(sample_f * 36000.0 * left_gain, -32000.0, 32000.0))
		var right_i: int = int(clampf(sample_f * 36000.0 * right_gain, -32000.0, 32000.0))
		data[i * 4] = left_i & 0xFF
		data[i * 4 + 1] = (left_i >> 8) & 0xFF
		data[i * 4 + 2] = right_i & 0xFF
		data[i * 4 + 3] = (right_i >> 8) & 0xFF

	stream.data = data
	return stream
