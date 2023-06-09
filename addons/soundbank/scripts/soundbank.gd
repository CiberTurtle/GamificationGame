extends Node

const SOUND_BANK_FOLDER := 'res://content/sounds/'
const FALLBACK_SOUND: AudioStreamWAV = preload('res://content/sounds/fallback.wav')
const POOL_SIZE := 32.

var bank := {}

var next_pool_index := 0
var player_pool: Array[AudioStreamPlayer2D] = []
func get_player() -> AudioStreamPlayer2D:
	var player := player_pool[next_pool_index]
	next_pool_index += 1
	if next_pool_index >= player_pool.size():
		next_pool_index = 0
	return player

func generate_pool(count: int) -> void:
	for i in count:
		var player := AudioStreamPlayer2D.new()
		add_child(player)
		player_pool.append(player)

func _ready() -> void:
	generate_pool(POOL_SIZE)

var loaded_sounds := {}
func get_sound(name: String) -> AudioStream:
	if loaded_sounds.has(name):
		return loaded_sounds[name]
	
	var sound := FALLBACK_SOUND
	var segs := name.split('.')
	#print(name)
	
	while segs.size() > 0:
		var path := SOUND_BANK_FOLDER + '.'.join(segs) + '.wav'
		if FileAccess.file_exists(path + '.import'):
			sound = load(path)
			break
		segs.remove_at(segs.size() - 1)
	
	loaded_sounds[name] = sound
	return sound

func play(name: String, position: Vector2) -> void:
	var player := get_player()
	var sound := get_sound(name.to_snake_case())
	player.stop()
	player.stream = sound
	player.position = position
	player.pitch_scale = randf_range(0.9, 1.1)
	player.volume_db = randf_range(-2.5, 2.5)
	player.play()

func play_ui(name: String) -> void:
	play(name, Vector2.ZERO)
