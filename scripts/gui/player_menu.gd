class_name PlayerMenu extends Control

var player_data: PlayerData

#@onready var ready_node: Control = %Ready
#@onready var controller_name: Button = %ControllerName
@onready var menu: Menu = %Menu
@onready var crow_sprite: Control = %CrownSprite
@onready var ready_button: Button = %ReadyButton

var leave_hold_timer := 0.

func _ready() -> void:
	if not is_instance_valid(player_data): return
	
	self_modulate = player_data.color
	say('Using ' + player_data.input.get_name(), true)
	
	crow_sprite.visible = player_data.is_leader
	
	update()
	update_skin()
	update_ready()

var is_first_frame := true
var previous_error := false
var skin_tween: Tween
var team_tween: Tween
func _process(delta: float) -> void:
	if not Game.player_datas.has(player_data):
		queue_free()
		return
	
	if say_timer > 0.:
		say_timer -= delta
		if say_timer <= 0:
			no_say()
	
	if not is_visible_in_tree(): return
	
	if is_first_frame:
		is_first_frame = false
		return
	
	if not player_data.input.is_device_connected():
		say('Disconnected!', .5)
		return
	
	if player_data.is_ready:
		if player_data.input.is_action_just_pressed('back'):
			player_data.is_ready = false
			update_ready()
			SoundBank.play_ui('ready')
			return
	else:
		if player_data.input.is_action_just_pressed('ok'):
			player_data.is_ready = true
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
			skin_anim()
			SoundBank.play_ui('ui_left')
			player_data.skin_index -= 1
			if player_data.skin_index < 0:
				player_data.skin_index = SkinDB.skins.size() - 1
			update_skin()
			return
		
		if player_data.input.is_action_just_pressed('right'):
			skin_anim()
			SoundBank.play_ui('ui_right')
			player_data.skin_index += 1
			if player_data.skin_index >= SkinDB.skins.size():
				player_data.skin_index = 0
			update_skin()
			return
		
		if player_data.input.is_action_just_pressed('team'):
			if is_instance_valid(team_tween):
				team_tween.kill()
			team_tween = create_tween()
			team_tween.set_ease(Tween.EASE_OUT)
			team_tween.set_trans(Tween.TRANS_BACK)
			team_tween.tween_property(%TeamSprite, 'scale', Vector2.ONE, 0.2).from(Vector2.ONE*1.33)
			
			match player_data.team:
				PlayerData.Team.None:
					player_data.team = PlayerData.Team.Alpha
					say('Alpha team', true)
					%TeamLabel.text = 'Alpha team'
					SoundBank.play_ui('ui_team.alpha')
				PlayerData.Team.Alpha:
					player_data.team = PlayerData.Team.Bravo
					say('Bravo team', true)
					%TeamLabel.text = 'Bravo team'
					SoundBank.play_ui('ui_team.bravo')
				_:
					say('No team', true)
					player_data.team = PlayerData.Team.None
					%TeamLabel.text = 'No team'
					SoundBank.play_ui('ui_team.none')
				
			%TeamSprite.region_rect.position.x = player_data.team * 16
			return

func skin_anim() -> void:
	if is_instance_valid(skin_tween):
		skin_tween.kill()
	skin_tween = create_tween()
	skin_tween.set_ease(Tween.EASE_OUT)
	skin_tween.set_trans(Tween.TRANS_BACK)
	skin_tween.tween_property(skin_sprite, 'scale', Vector2.ONE, 0.2).from(Vector2.ONE*1.33)

@onready var say_control: Control = %Say
@onready var say_label: Label = %SayLabel
var say_timer := 0.
var say_tween: Tween
func say(text: String, auto_hide := false) -> void:
	if is_instance_valid(say_tween):
		say_tween.kill()
	say_tween = create_tween()
	say_tween.set_ease(Tween.EASE_OUT)
	say_tween.set_trans(Tween.TRANS_BACK)
	say_tween.tween_property(say_control, 'scale', Vector2.ONE, 0.2).from(Vector2.ONE*1.33)
	#create_tween().tween_property(say_control, 'scale', Vector2.ONE, 0.2).from(Vector2(1.1, 1.1)).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#say_control.pivot_offset.x = say_control.size.x/2.
	#say_control.pivot_offset.y = say_control.size.y
	
	say_control.show()
	say_label.text = text
	
	if auto_hide:
		say_timer = 2.

func no_say() -> void:
	say_control.hide()

func update_ready() -> void:
	if player_data.is_ready:
		if player_data == Game.player_datas[Game.player_turn_index]:
			say('Picking stage...')
		else:
			say('Ready!')
	else:
		no_say()
	
	ready_button.visible = not player_data.is_ready
	for child in skin_sprite.get_children():
		child.visible = not player_data.is_ready

@onready var skin_sprite: NinePatchRect = %SkinSprite
@onready var skin_name_label: Label = %SkinNameLabel
func update_skin() -> void:
	skin_sprite.texture = SkinDB.skins[player_data.skin_index]
	skin_sprite.region_rect = SkinDB.get_skin_region(skin_sprite.texture, player_data.color_index)
	skin_sprite.region_rect.size = Vector2(32, 32)
	skin_name_label.text = SkinDB.skin_names[player_data.skin_index]

func update() -> void:
	if not is_instance_valid(player_data): return
	%StatsLabel.text = '%s kills   %s deaths' % [player_data.kills, player_data.deaths]
	update_ready()
	update_skin()
