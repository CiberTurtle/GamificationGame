extends Line2D


func _ready():
	top_level = true
	add_point(owner.damage_source.holder_node2d.global_position)
	add_point(owner.global_position)

func _process(delta):
	set_point_position(0, owner.damage_source.holder_node2d.global_position)
	set_point_position(1, owner.global_position)
