extends Projectile

@export var explosion: PackedScene

func die() -> void:
	death.emit()
	var proj = explosion.instantiate() as Node2D
	proj.transform = global_transform
	proj.damage_source = damage_source
	Globals.world.add_child(proj)
	queue_free()
