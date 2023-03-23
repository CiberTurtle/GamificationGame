class_name Menu extends Control

var index := 0

var input: DeviceInput

func _process(delta: float) -> void:
	process_inputs()

func process_inputs() -> void:
	if not is_instance_valid(input) or not input.is_device_connected(): return
	
	if input.is_action_just_pressed('down'):
		index += 1
		if index < 0:
			index = 0
		return
	
	if input.is_action_just_pressed('up'):
		index -= 1
		if index < 0:
			index = 0
		return
