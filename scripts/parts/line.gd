extends Line2D

func _ready() -> void:
	top_level = true
	#if not is_instance_valid(owner.damage_source.player): return
	#add_point(owner.damage_source.player.holder_node2d.global_position)
	add_point(owner.global_position)

var index := 0
func _process(delta: float) -> void:
	for i in 10:
		set_point_position(index, get_point_position(index) + Vector2.DOWN*16.*delta)
		
		index += 1
		if index >= get_point_count():
			index = 0

var counter := 0
func _physics_process(delta: float) -> void:
	counter += 1
	if counter > 3:
		counter = 0
		add_point(owner.global_position)
