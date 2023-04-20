extends CharacterBody2D

const TPS := 60.
signal death()

@export_range(0, 60, 1, 'or_greater', 'suffix:ticks')  var lifetime := 60
@onready var lifetime_sec := lifetime/TPS
var age := 0.0

@export var speed_over_lifetime: Curve

@export_range(0, 10, 1, 'or_greater', 'suffix:count')  var max_hits := 1
var hits := 0
var damage_source: PlayerData
@export var random_skew:=false
@export var skew_curve:Curve
var proj_skew:float

func _ready() -> void:
	var hitboxes := find_children('PassiveHitbox')
	if random_skew:
		proj_skew = randf_range(-1, 1)
	else:
		proj_skew = 1
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
	var motion := Vector2(transform.basis_xform(Vector2.RIGHT).x, skew_curve.sample_baked(age_ratio) * proj_skew).normalized() * delta * speed
	var hit := move_and_collide(motion)
	
	if hit:
		die()
		return
	
	age += delta
	if age > lifetime_sec:
		die()
		return

func die() -> void:
	death.emit()
	queue_free()
