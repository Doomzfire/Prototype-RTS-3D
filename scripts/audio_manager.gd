extends Node
class_name AudioManager

static var instance: AudioManager

@export var cooldown := 0.08

var _last_played := {}

func _ready() -> void:
	instance = self

func play_sfx(event_name: String) -> void:
	var now := Time.get_ticks_msec() / 1000.0
	if _last_played.has(event_name) and now - _last_played[event_name] < cooldown:
		return
	_last_played[event_name] = now

	var player := AudioStreamPlayer.new()
	player.bus = "SFX"
	player.stream = _generate_beep(event_name)
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()

func _generate_beep(event_name: String) -> AudioStreamWAV:
	var sample_rate := 22050
	var duration := 0.08
	var frames := int(sample_rate * duration)
	var buffer := PackedByteArray()
	buffer.resize(frames * 2)

	var freq := 440.0
	match event_name:
		"select": freq = 660.0
		"order": freq = 550.0
		"attack_hit": freq = 770.0
		"death": freq = 220.0

	for i in frames:
		var t := float(i) / sample_rate
		var value := sin(TAU * freq * t) * (1.0 - t / duration)
		var sample := int(clamp(value * 32767.0, -32768.0, 32767.0))
		buffer[i * 2] = sample & 0xFF
		buffer[i * 2 + 1] = (sample >> 8) & 0xFF

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	stream.data = buffer
	return stream
