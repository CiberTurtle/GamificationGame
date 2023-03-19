extends PanelContainer

signal pick(scene: PackedScene)

@export_dir var folder := ''

var items := PackedStringArray()

@onready var item_list: ItemList = %ItemList

func _ready() -> void:
	reload()

func reload() -> void:
	print('reload')
	items.clear()
	item_list.clear()
	var files := DirAccess.get_files_at(folder)
	for file in files:
		print(file)
		if not file.ends_with('.tscn'): continue
		items.append(file)
		item_list.add_item(file.trim_suffix('.tscn'))

func _on_item_list_item_activated(index: int) -> void:
	var item := items[index]
	var scene_path := folder + '/' + item
	var scene := load(scene_path) as PackedScene
	pick.emit(scene)
