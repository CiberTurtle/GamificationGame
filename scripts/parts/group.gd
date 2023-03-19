extends Node

func trigger() -> void:
	for child in get_children():
		if not child.visible: continue
		if not child.has_method('trigger'): continue
		child.call('trigger')
