extends Node

var player_scene: PackedScene = preload('res://scenes/player.tscn')

var player_colors: PackedColorArray = [
	Color('#EF4A3A'),
	Color('#3385B8'),
	Color('#6BA841'),
	Color('#CD6093'),
	#Color('#F4B41B'),
	#Color('#808080'),
	#Color.from_ok_hsl(0, 0, 0.67),
	#Color.from_ok_hsl(0, 0, 0.33),
]
