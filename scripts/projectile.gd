extends CharacterBody2D

const TPS := 60.

@export_range(0, 60, 1, 'or_greater', 'suffix:ticks')  var lifetime := 60
@onready var lifetime_sec := lifetime/TPS
@export var skew_amount :=0.0
var age := 0.0

@export var speed_over_lifetime: Curve

@export_range(0, 10, 1, 'or_greater', 'suffix:count')  var max_hits := 1
var hits := 0
var damage_source: Player
@onready var proj_skew = randf_range(-skew_amount, skew_amount)

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
	var age_ratio := age/lifetime_sec
	var speed := speed_over_lifetime.sample_baked(age_ratio)
	var motion := Vector2(transform.basis_xform(Vector2.RIGHT).x, proj_skew).normalized() * delta * speed
	var hit := move_and_collide(motion)
	
	if hit:
		die()
		return
	
	age += delta
	if age > lifetime_sec:
		die()
		return

func die() -> void:
	queue_free()
