extends Node

const LEVEL_FOLDER := 'res://levels/'
const THUMBNAIL_FOLDER := 'res://content/thumbnails/'
const PLACEHOLDER_THUMBNAIL := 'res://content/thumbnails/placeholder.svg'

var level_paths: Array[String] = []
var level_names: Array[String] = []
var level_thumbnails: Array[CompressedTexture2D] = []

func _enter_tree() -> void:
	for file in DirAccess.get_files_at(LEVEL_FOLDER):
		if not file.ends_with('.tscn'): continue
		var file_name := file.trim_suffix('.tscn')
		var path := LEVEL_FOLDER + file
		var thumbnail_path := THUMBNAIL_FOLDER + file_name.to_lower() + '.svg'
		if not FileAccess.file_exists(thumbnail_path):
			thumbnail_path = PLACEHOLDER_THUMBNAIL
		
		var level_thumbnail := load(thumbnail_path) as CompressedTexture2D
		
		level_paths.append(path)
		level_names.append(file_name.capitalize())
		level_thumbnails.append(level_thumbnail)
