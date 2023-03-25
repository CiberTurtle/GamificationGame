extends Node

const SKINS_FOLDER := 'res://content/sprites/skins/'

var skins: Array[CompressedTexture2D]
var skin_names: Array[String]

func _enter_tree() -> void:
	for file in DirAccess.get_files_at(SKINS_FOLDER):
		if not file.ends_with('.png.import'): continue
		file = file.trim_suffix('.import')
		
		var path := SKINS_FOLDER + file
		
		var skin := load(path) as CompressedTexture2D
		if not skin: continue
		
		skins.append(skin)
		skin_names.append(file.trim_suffix('.png').capitalize())

func get_skin_region(skin: CompressedTexture2D, color_index: int) -> Rect2:
	var rect := Rect2(0, 0, 64, 64)
	if skin.get_size() == Vector2(128, 128):
		rect.size = Vector2(64, 64)
		if color_index == 1 or color_index == 3:
			rect.position.x = 64
		if color_index >= 2:
			rect.position.y = 64
	return rect
