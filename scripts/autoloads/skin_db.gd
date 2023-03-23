extends Node

const SKINS_FOLDER := 'res://content/sprites/skins/'

var skins: Array[CompressedTexture2D]
var skin_names: Array[String]

func _enter_tree() -> void:
	for file in DirAccess.get_files_at(SKINS_FOLDER):
		var path := SKINS_FOLDER + file
		if not path.ends_with('.png'): continue
		
		var skin := load(path) as CompressedTexture2D
		if not skin: continue
		
		skins.append(skin)
		skin_names.append(file.trim_suffix('.png').capitalize())
