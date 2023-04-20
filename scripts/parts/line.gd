extends Line2D

func _ready() -> void:
	top_level = true
	add_point(owner.global_position)
	add_point(owner.global_position)

func _physics_process(delta: float) -> void:
	set_point_position(1, owner.global_position)
