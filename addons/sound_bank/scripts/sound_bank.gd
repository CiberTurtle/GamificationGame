extends Node

const SOUND_BANK_FOLDER := 'res://content/sounds/'
const FALLBACK_SOUND: AudioStreamWAV = preload('res://content/sounds/fallback.wav')
const POOL_SIZE := 16.

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
	reload_bank()
	generate_pool(POOL_SIZE)

func reload_bank() -> void:
	bank.clear()
	scan_folder(SOUND_BANK_FOLDER)

func scan_folder(path: String) -> void:
	for file in DirAccess.get_files_at(path):
		if file.ends_with('.wav'):
			#bank[dir+file]
			pass
	for folder in DirAccess.get_directories_at(path):
		scan_folder(path + '/' + folder)

var loaded_sounds := {}
func get_sound(name: String) -> AudioStream:
	if loaded_sounds.has(name):
		return loaded_sounds[name]
	var path := SOUND_BANK_FOLDER + name + '.wav'
	var sound := FALLBACK_SOUND
	if FileAccess.file_exists(path):
		sound = load(path)
	loaded_sounds[name] = sound
	return sound

func play(name: String, position: Vector2) -> void:
	var player := get_player()
	var sound := get_sound(name)
	player.stop()
	player.stream = sound
	player.position = position
	player.play()
