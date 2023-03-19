class_name PlayerInput extends RefCounted

signal connection_changed(coonect: bool)

# -2:	WASD
# -1:	Arrow keys
# 0+:	Gamepad
var device_id: int

func is_gamepad() -> bool:
	return device_id >= 0

func is_wasd() -> bool:
	return device_id == -1

func is_arrows() -> bool:
	return device_id == -2

func get_name() -> String:
	if is_wasd(): return 'WASD'
	if is_arrows(): return 'Arrow Keys'
	if device_id < 0: return 'Unknown'
	return Input.get_joy_name(device_id)

func get_guid() -> String:
	if is_wasd(): return 'wasd'
	if is_arrows(): return 'arrows'
	if device_id < 0: return 'unknown'
	return Input.get_joy_guid(device_id)

func is_known() -> bool:
	if is_wasd() or is_arrows(): return true
	if device_id < 0: return false
	return Input.is_joy_known(device_id)

func get_action_pressed(action: StringName) -> bool:
	match device_id:
		-2: # wasd
			match action:
				'left': return Input.is_physical_key_pressed(KEY_A)
				'right': return Input.is_physical_key_pressed(KEY_D)
				'up': return Input.is_physical_key_pressed(KEY_W)
				'down': return Input.is_physical_key_pressed(KEY_S)
				'action': return Input.is_physical_key_pressed(KEY_E)
		-1: # arrows
			match action:
				'left': return Input.is_physical_key_pressed(KEY_LEFT)
				'right': return Input.is_physical_key_pressed(KEY_RIGHT)
				'up': return Input.is_physical_key_pressed(KEY_UP)
				'down': return Input.is_physical_key_pressed(KEY_DOWN)
				'action': return Input.is_physical_key_pressed(KEY_CTRL) or Input.is_physical_key_pressed(KEY_SHIFT)
		_:
			if device_id < 0:
				# unknown device
				printerr('unknown device id of ' + str(device_id))
				return false
			
			match action:
				'left': return Input.is_joy_button_pressed(device_id, JOY_BUTTON_DPAD_LEFT)
				'right': return Input.is_joy_button_pressed(device_id, JOY_BUTTON_DPAD_RIGHT)
				'up': return Input.is_joy_button_pressed(device_id, JOY_BUTTON_DPAD_UP)
				'down': return Input.is_joy_button_pressed(device_id, JOY_BUTTON_DPAD_DOWN)
				'action': return Input.is_joy_button_pressed(device_id, JOY_BUTTON_A)
			
	return false
