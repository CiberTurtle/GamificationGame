extends ReferenceRect

@export var multiplier := 1
@export var loottable_override: Loottable

const CRATE_SCENE := preload('res://items/crate.tscn')

var next_spawn := 0.
func _process(delta: float) -> void:
	next_spawn -= delta
	if next_spawn < 0.:
		next_spawn = 3./multiplier
		spawn()

func spawn() -> void:
	var scene := loottable_override.pick() if loottable_override else CRATE_SCENE
	var item := scene.instantiate() as Item
	item.position = position + Vector2(randf_range(0, size.x), randf_range(0, size.y))
	Globals.world.add_child(item)
