extends Item

var is_flying:=false
@onready var hitbox:= $Hitbox
func check_pickup():
	return !is_flying

const TPS := 60.

@export_range(0, 60, 1, 'or_greater', 'suffix:ticks')  var lifetime := 60
@onready var lifetime_sec := lifetime/TPS
var age := 0.0
@export var pickup_range := 16.
@export var speed_over_lifetime: Curve
@export var roations_per_second:=2.
@export var to_rotate:Node2D
var backwards := false
@export_range(0, 10, 1, 'or_greater', 'suffix:count')  var max_hits := 1
var hits := 0

func _ready() -> void:
	var hitboxes := find_children('*', 'Hitbox')
	for hitbox in hitboxes:
		hitbox.attack.connect(
		func(node: Node2D):
			hits += 1
			if hits >= max_hits:
				die()
		)

func _physics_process(delta: float) -> void:
	hitbox.auto_attack = is_flying
	if is_flying:
		var age_ratio := age/lifetime_sec
		var speed := speed_over_lifetime.sample_baked(age_ratio)
		if !backwards && speed < 0:
			backwards = true
			hitbox.forget_hits()
		var motion := transform.basis_xform(Vector2.RIGHT)*speed*delta
		var hit := move_and_collide(motion)
		to_rotate.rotate(roations_per_second * 2 * PI * delta)
		
		if hit:
			if backwards:
				is_flying = false
				to_rotate.rotation = 0.
			else:
				backwards = true
			return
		
		age += delta
		
		if not is_instance_valid(damage_source.player):
			queue_free()
			return
		
		if age > lifetime_sec / 2 && position.distance_squared_to(damage_source.player.position) < pickup_range * pickup_range:
			is_flying = false
			to_rotate.rotation = 0.
			damage_source.player.try_pickup_item(self)
	super._physics_process(delta)

func _process_notheld(delta):
	if !is_flying:
		process_notheld_gravity(delta)


func _on_use():
	hitbox.forget_hits()
	player.try_drop_item()
	is_flying = true
	age = 0.
