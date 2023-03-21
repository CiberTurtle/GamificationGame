extends Line2D

func _ready() -> void:
	top_level = true
	if not is_instance_valid(owner.damage_source.player): return
	add_point(owner.damage_source.player.holder_node2d.global_position)
	add_point(owner.global_position)

func _process(delta) -> void:
	if not is_instance_valid(owner.damage_source.player): return
	set_point_position(0, owner.damage_source.player.holder_node2d.global_position)
	set_point_position(1, owner.global_position)
