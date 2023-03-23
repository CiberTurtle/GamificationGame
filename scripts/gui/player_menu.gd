class_name PlayerMenu extends Control

var player_data: PlayerData
var is_ready := false

#@onready var ready_node: Control = %Ready
#@onready var controller_name: Button = %ControllerName
@onready var menu: Menu = %Menu
@onready var crow_sprite: Control = %CrownSprite
@onready var ready_button: Button = %ReadyButton

var leave_hold_timer := 0.

func _ready() -> void:
	if not player_data: return
	
	self_modulate = player_data.color
	say('On ' + player_data.input.get_name(), true)
	
	crow_sprite.visible = player_data.is_leader
	
	update_skin()
	update_ready()
	SoundBank.play_ui('join')

var is_first_frame := true
func _process(delta: float) -> void:
	if not Game.player_datas.has(player_data):
		queue_free()
		return
	
	if say_timer > 0.:
		say_timer -= delta
		if say_timer <= 0:
			say_control.hide()
	
	if not is_visible_in_tree(): return
	
	if is_first_frame:
		is_first_frame = false
		return
	
	if is_ready:
		if player_data.input.is_action_just_pressed('back'):
			is_ready = false
			update_ready()
			SoundBank.play_ui('ready')
			return
	else:
		if player_data.input.is_action_just_pressed('ok'):
			is_ready = true
			update_ready()
			SoundBank.play_ui('unready')
			return
		
		if player_data.input.is_action_pressed('back'):
			leave_hold_timer += delta
			if leave_hold_timer > .5:
				SoundBank.play_ui('leave')
				Game.player_datas.erase(player_data)
				queue_free()
			return
		else:
			leave_hold_timer = 0.
		
		if player_data.input.is_action_just_pressed('left'):
			player_data.skin_index -= 1
			if player_data.skin_index < 0:
				player_data.skin_index = SkinDB.skins.size() - 1
			update_skin()
			return
		
		if player_data.input.is_action_just_pressed('right'):
			player_data.skin_index += 1
			if player_data.skin_index >= SkinDB.skins.size():
				player_data.skin_index = 0
			update_skin()
			return

@onready var say_control: Control = %Say
@onready var say_label: Label = %SayLabel
var say_timer := 0.
func say(text: String, auto_hide := false) -> void:
	#create_tween().tween_property(say_control, 'scale', Vector2.ONE, 0.2).from(Vector2(1.1, 1.1)).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#say_control.pivot_offset.x = say_control.size.x/2.
	#say_control.pivot_offset.y = say_control.size.y
	
	say_control.show()
	say_label.text = text
	
	if auto_hide:
		say_timer = 2.

func update_ready() -> void:
	if is_ready:
		say('Ready!')
	else:
		say_control.hide()
	
	ready_button.visible = not is_ready

@onready var skin_sprite: NinePatchRect = %SkinSprite
@onready var skin_name_label: Label = %SkinNameLabel
func update_skin() -> void:
	skin_sprite.texture = SkinDB.skins[player_data.skin_index]
	skin_name_label.text = SkinDB.skin_names[player_data.skin_index]
