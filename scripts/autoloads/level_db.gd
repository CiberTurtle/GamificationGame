extends Node

const LEVEL_FOLDER := 'res://levels/'
const THUMBNAIL_FOLDER := 'res://content/thumbnails/'

var level_paths: Array[String] = []
var level_names: Array[String] = []
var level_thumbnails: Array[CompressedTexture2D] = []

func _enter_tree() -> void:
	for file in DirAccess.get_files_at(LEVEL_FOLDER):
		if not file.ends_with('.tscn'): continue
		var file_name := file.trim_suffix('.tscn')
		var path := LEVEL_FOLDER + file
		var thumbnail_path := THUMBNAIL_FOLDER + file_name + '.png'
		
		var level_thumbnail: CompressedTexture2D = preload('res://content/sprites/gui/level_thumbnail_placeholder.png')
		if FileAccess.file_exists(thumbnail_path):
			level_thumbnail = load(thumbnail_path)
		
		level_paths.append(path)
		level_names.append(file_name.capitalize())
		level_thumbnails.append(level_thumbnail)
