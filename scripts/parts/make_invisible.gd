extends Node2D

const TPS := 60.
@export_range(0, 60, 1, 'or_greater', 'suffix:ticks') var ticks:=1
@export_node_path("Sprite2D") var sprite
var invis_time:=0.

func trigger():
	get_node(sprite).visible = false
	invis_time = ticks / TPS
	
func _process(delta):
	invis_time -= delta
	if invis_time < 0:
		get_node(sprite).visible = true
