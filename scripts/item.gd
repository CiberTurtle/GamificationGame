class_name Item extends CharacterBody2D

signal pickup()
signal drop()
signal use()
signal death()

@export_placeholder('Give me a name...') var item_name: String
@export_range(0, 100, 1, 'or_greater', 'suffix:hp') var base_health := 50
@onready var health := base_health

@export_group('Common')
@export_range(0, 128, 1, 'or_greater', 'suffix:px/s') var grounded_dec := 512.
@export_range(0, 256, 1, 'or_greater', 'suffix:px/s') var gravity := 512.
@export_range(0, 256, 1, 'or_greater', 'suffix:px/s') var max_fall_speed := 256.

var cooldown := 0.
var player: Player
var damage_source: Player

@onready var on_use := $OnUse

func is_held() -> bool:
	return player != null

func check_pickup() -> bool:
	return not is_held()

func check_drop() -> bool:
	return true

func check_use() -> bool:
	if cooldown > 0: return false
	return true

func _physics_process(delta: float) -> void:
	cooldown -= delta
	if is_held():
		_process_held(delta)
	else:
		_process_notheld(delta)

func _process_held(delta: float) -> void:
	pass

func _process_notheld(delta: float) -> void:
	process_notheld_gravity(delta)

func process_notheld_gravity(delta: float) -> void:
	velocity.y += gravity*delta
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	
	if is_on_wall():
		velocity.x = 0.
	if is_on_ceiling() and velocity.y < 0.:
		velocity.y = 0.
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0., grounded_dec*delta)
		if velocity.y > 0.:
			velocity.y = 0.
	
	move_and_slide()

func take_damage(damage: int, source: Player) -> bool:
	if player: return false # don't take damage if held
	if health < 0: return false
	
	health -= damage
	if health < 0:
		die()
	
	return true

func die() -> void:
	#assert(not player, 'item somehow died while being held, this should not happen')
	death.emit()
	queue_free()
