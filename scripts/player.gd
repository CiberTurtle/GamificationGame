class_name Player extends CharacterBody2D

signal death()

const TPS = 60.

var player_data: PlayerData
@onready var input := player_data.input

@export_range(0, 100, 1, 'or_greater', 'suffix:hp') var base_health := 100
@onready var health := base_health
@export var item_drop_velocity := Vector2(16., -16.)

@export_group('Movement', 'move_')
@export_range(0, 128., 1, 'or_greater', 'suffix:px/s') var move_speed := 64.
@export_range(0, 128., 1, 'or_greater', 'suffix:px/s') var move_crouch_speed := 32.

@export_range(0, 60, 1, 'or_greater', 'suffix:ticks') var move_acc_ticks := 4.
@onready var move_acc_time := move_acc_ticks / TPS
@export_range(0, 60, 1, 'or_greater', 'suffix:ticks') var move_dec_ticks := 6.
@onready var move_dec_time := move_dec_ticks / TPS
@export_range(0, 60, 1, 'or_greater', 'suffix:ticks') var move_opp_ticks := 2.
@onready var move_opp_time := move_opp_ticks / TPS

@export_range(0, 60, 1, 'or_greater', 'suffix:ticks') var move_acc_air_ticks := 8.
@onready var move_acc_air_time := move_acc_air_ticks / TPS
@export_range(0, 60, 1, 'or_greater', 'suffix:ticks') var move_dec_air_ticks := 12.
@onready var move_dec_air_time := move_dec_air_ticks / TPS
@export_range(0, 60, 1, 'or_greater', 'suffix:ticks') var move_opp_air_ticks := 4.
@onready var move_opp_air_time := move_opp_air_ticks / TPS

@export_group('Jump')
@export_range(0, 128, 1, 'or_greater', 'suffix:px') var jump_height := 48.
@export_range(0, 120, 1, 'or_greater', 'suffix:ticks') var jump_ticks := 60
@onready var gravity := Calc.jump_gravity(jump_height, jump_ticks/TPS)
@onready var jump_velocity := Calc.jump_velocity(jump_height, gravity)

## The maxinum falling speed based on the jumping speed
@export var max_fall_ratio := 2.
@onready var max_fall_speed := jump_velocity*max_fall_ratio
@export var extra_fall_mult := 1.5
var is_jumping := false

@export_group('Assits')
## The amount of time the player can still jump after leaving a platform, see 'Looney Tunes'
@export_range(0, 60, 1, 'or_greater', 'suffix:ticks') var coyote_time_ticks := 6
var coyote_timer := -1.
@export_range(0, 60, 1, 'or_greater', 'suffix:ticks') var jump_buffer_ticks := 6
var jump_buffer_timer := -1.

## If the player hits their head on a cornner then how far can they be nuged out of the way
@export_range(0, 16, 1, 'or_greater', 'suffix:px') var max_bonknuge_distance := 4.

@export_range(0, 60, 1, 'or_greater', 'suffix:ticks')  var action_buffer_ticks := 6
var action_buffer_timer := -1.

@export_group('Climbing', 'climb_')
@export var climb_speed_vertical := 64.
@export var climb_speed_horizontal := 32.
@export var climb_coyote_time_ticks := 10
var is_clibing := false

@export_group('Other')
@export_range(0, 128., 1, 'or_greater', 'suffix:px/s')  var extra_ground_dec := 128.
@export_range(0, 128., 1, 'or_greater', 'suffix:px/s')  var extra_air_dec := 0.

var held_item: Item

@onready var flip_node2d: Node2D = %Flip
@onready var holder_node2d: Node2D = %Holder
@onready var pickup_area: Area2D = %PickupArea
@onready var ladder_dectector_area: Area2D = %LadderDetectorArea
@onready var punch_area: Hitbox = %PunchArea
@onready var health_bar: ProgressBar = %HealthBar
@export var punch_effect:PackedScene

func _ready() -> void:
	if is_instance_valid(player_data.player):
		printerr('I should not exsist. An extra player was spawned and killed.')
		health = -base_health
		queue_free()
		return
	player_data.player = self
	update_health_bar()
	health_bar.modulate = player_data.color

func _process(delta: float) -> void:
	process_inputs()

func reset_movement() -> void:
	speed_move = 0.
	speed_extra = 0.
	speed_vertical = 0.
	
	is_jumping = false

var input_move := Vector2.ZERO
var input_jump := false
func process_inputs() -> void:
	input_move = Vector2.ZERO
	input_jump = false
	if not input.is_device_connected(): return
	
	input_move.x = input.get_axis('left', 'right')
	input_move.y = input.get_axis('up', 'down')
	
	input_jump = input.is_action_pressed('jump')
	if input.is_action_just_pressed('jump'):
		jump_buffer_timer = jump_buffer_ticks / TPS
	
	if input.is_action_just_pressed('action'):
		action_buffer_timer = action_buffer_ticks / TPS

var speed_move := 0.
var speed_extra := 0.
var speed_vertical := 0.
var direction := 1.
func _physics_process(delta: float) -> void:
	if is_dead: return
	if health <= 0:
		die()
		return
	
	last_damage_timer += delta
	inv_timer -= delta
	
	last_damage_timer -= delta
	
	if input_move.x != 0:
		direction = sign(input_move.x)
	flip_node2d.scale.x = direction
	
	if is_clibing:
		process_state_climb(delta)
	else:
		process_state_platformer(delta)
	
	if position.y > Globals.level.height/2. + 16.:
		die()
	return

func process_state_platformer(delta: float) -> void:
	if is_on_floor():
		is_jumping = false
	
	if ladder_dectector_area.get_overlapping_bodies().size() > 0 and input_move.y < 0 and speed_vertical > -climb_speed_vertical:
		is_clibing = true
		is_jumping = false
		return
	
	process_movement(delta)
	process_gravity(delta)
	process_jump(delta)
	move()
	
	process_action(delta)

var jumped_from_ladder := false
func process_state_climb(delta: float) -> void:
	if ladder_dectector_area.get_overlapping_bodies().size() == 0 or (is_on_floor() and input_move.y > 0):
		is_clibing = false
		coyote_timer = climb_coyote_time_ticks/TPS
		return
	
	speed_vertical = input_move.y * climb_speed_vertical
	speed_move = input_move.x * climb_speed_horizontal
	speed_extra = 0.
	
	if jump_buffer_timer > 0.:
		jump_buffer_timer = -1.
		coyote_timer = -1.
		speed_vertical = -jump_velocity
		is_jumping = true
		is_clibing = false
		return
	
	move()
	
	process_action(delta)

func move() -> void:
	velocity.x = (speed_move + speed_extra)
	velocity.y = speed_vertical
	
	move_and_slide()

func process_movement(delta: float) -> void:
	var is_grounded := is_on_floor()
	var is_input_opposing = speed_move != 0. and sign(speed_move) != sign(input_move.x)
	
	var speed := 0.0
	if is_grounded: # grounded movement
		if input_move.x != 0.0:
			if is_input_opposing: # opposing movement
				speed = move_speed/(move_opp_time/delta)
			else:
				speed = move_speed/(move_acc_time/delta)
		else:
			speed_move = move_toward(speed_move, 0., move_speed/(move_dec_time/delta))
		speed_extra = move_toward(speed_extra, 0., extra_ground_dec*delta)
	else: # air movement
		if input_move.x != 0.0:
			if is_input_opposing: # opposing movement
				speed = move_speed/(move_opp_air_time/delta)
			else:
				speed = move_speed/(move_acc_air_time/delta)
		else:
			speed_move = move_toward(speed_move, 0., move_speed/(move_dec_air_time/delta))
		speed_extra = move_toward(speed_extra, 0., extra_air_dec*delta)
	
	speed_move += input_move.x * speed
	var max_speed := move_crouch_speed if input_move.y > 0. else move_speed
	speed_move = clamp(speed_move, -max_speed, max_speed)
	
	var hit_wall_on_left := is_on_wall() and test_move(transform, Vector2.LEFT)
	var hit_wall_on_right := is_on_wall() and test_move(transform, Vector2.RIGHT)
	
	if hit_wall_on_left:
		if speed_move < 0.:
			speed_move = -1.
		if speed_extra < 0.: 
			speed_extra = 0.
	
	if hit_wall_on_right:
		if speed_move > 0.:
			speed_move = 1.
		if speed_extra > 0.: 
			speed_extra = 0.

func process_gravity(delta: float) -> void:
	if is_on_ceiling():
		if !try_bonknudge(max_bonknuge_distance*direction):
			if speed_vertical < 0.: speed_vertical = 0.
	
	if is_on_floor():
		if speed_vertical > 0.:
			speed_vertical = 0.
	else:
		speed_vertical += gravity*(1. if input_jump else extra_fall_mult)*delta
	
	if speed_vertical > max_fall_speed:
		speed_vertical = max_fall_speed

func try_bonknudge(distance: float) -> bool:
	var x := 0.
	while x != distance:
		if !test_move(transform.translated(Vector2(x, 0.)), Vector2.UP):
			position.x += x
			return true
		x = move_toward(x, distance, 1)
	return false

func process_jump(delta: float) -> void:
	coyote_timer -= delta
	if is_on_floor():
		coyote_timer = coyote_time_ticks / TPS
	
	if jump_buffer_timer > 0.:
		if input_move.y > 0.: # if chrouching then fall though
			SoundBank.play('fallthrough', position)
			jump_buffer_timer = 0.
			position.y += 1.
		elif coyote_timer > 0.: # or else jump
			SoundBank.play('jump', position)
			is_jumping = true
			coyote_timer = 0.
			jump_buffer_timer = 0.
			
			speed_vertical = -jump_velocity
	jump_buffer_timer -= delta

func process_action(delta: float) -> void:
	if action_buffer_timer <= 0.: return
	action_buffer_timer -= delta
	
	if is_instance_valid(held_item):
		if input_move.y > 0 and not is_clibing:
			try_drop_item()
			action_buffer_timer = -1.
			return
		
		if held_item.check_use():
			action_buffer_timer = -1.
			held_item.use.emit()
		return
	
	if input_move.y > 0:
		var nodes := pickup_area.get_overlapping_bodies()
		var closest_item: Item
		var closest_distance_sqr := 1./0.
		
		for node in nodes:
			var it := node as Item
			if not it: continue # not an item
			if it.player: continue # already is held by another player
			
			var distance := position.distance_squared_to(it.position)
			if distance < closest_distance_sqr:
				closest_item = it
				closest_distance_sqr = distance
		
		if closest_item and closest_item.check_pickup():
			try_pickup_item(closest_item)
			action_buffer_timer = -1.
	else:
		SoundBank.play('punch', position)
		action_buffer_timer = -1.
		punch_area.attack_overlap(player_data)
		var effect = punch_effect.instantiate() as Node2D
		holder_node2d.add_child(effect)

func try_pickup_item(item: Item) -> bool:
	if is_instance_valid(held_item): return false
	#assert(not held_item, 'cannot pick up item - an item is already being held')
	
	item.player = self
	item.damage_source = player_data
	item.pickup.emit()
	# item was killed when it was picked up
	if not is_instance_valid(item):
		return false
	
	item.reparent(holder_node2d)
	item.transform = Transform2D.IDENTITY
	held_item = item
	return true

func try_drop_item() -> bool:
	if not is_instance_valid(held_item): return false
	var can_drop := held_item.check_drop()
	if not can_drop: return false
	
	held_item.velocity.x = item_drop_velocity.x*direction
	held_item.velocity.y = item_drop_velocity.y
	
	held_item.drop.emit()
	held_item.reparent.call_deferred(Globals.world)
	held_item.player = null
	held_item = null
	
	return true

var inv_timer := -1.
var last_damage_source: PlayerData
var last_damage_timer := 0.
var is_dead := false
func take_damage(damage: int, source: PlayerData) -> bool:
	if health <= 0: return false # already dead, don't die again
	if inv_timer > 0. and damage < 420: return false # is invulerable, don't take damage
	if is_instance_valid(source) and source.guid == player_data.guid: return false # hitting it's self, don't
	
	if source:
		last_damage_source = source
	last_damage_timer = 0.
	
	health -= damage
	update_health_bar()
	
	if damage > 25:
		SoundBank.play('hit.player.big', position)
	else:
		SoundBank.play('hit.player', position)
	
	if health <= 0:
		die()
	
	var spawn_fx := preload('res://scenes/fx/hurt_puff.tscn').instantiate() as Node2D
	spawn_fx.global_position = global_position
	spawn_fx.modulate = player_data.color
	Globals.world.add_child(spawn_fx)
	
	return true

func die() -> void:
	is_dead = true
	SoundBank.play('death.player', position)
	death.emit()
	Game.player_died.emit(self)
	
	var spawn_fx := preload('res://scenes/fx/death_puff.tscn').instantiate() as Node2D
	spawn_fx.global_position = global_position
	spawn_fx.modulate = player_data.color
	Globals.world.add_child(spawn_fx)

func update_health_bar() -> void:
	if is_instance_valid(health_bar):
		health_bar.value = ceil(float(health)/base_health*health_bar.max_value)
	#health_bar.max_value = base_health
