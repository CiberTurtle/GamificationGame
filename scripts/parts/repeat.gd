extends Node

@export var count := 3
@export_range(0, 60, 1, 'or_greater', 'suffix:ticks') var delay_btw := 10

func trigger() -> void:
	for i in count:
		relay()
		
		if delay_btw > 0:
			await get_tree().create_timer(delay_btw/60., false, true, true).timeout

func relay() -> void:
	for child in get_children():
		if not child.visible: continue
		if not child.has_method('trigger'): continue
		await child.call('trigger')
