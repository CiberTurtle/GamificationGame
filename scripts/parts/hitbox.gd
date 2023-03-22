class_name Hitbox extends Area2D

signal attack(node: Node2D)

@export_range(0, 100, 1, 'or_greater', 'suffix:hp') var damage := 1
@export var auto_attack := false
@export var remember_hits := false

@export var speed_threshold := 0.

var things_hit: Array[Node2D] = []
func forget_hits():
	things_hit.clear()

func _ready() -> void:
	body_entered.connect(
		func(body: PhysicsBody2D):
			if not auto_attack: return
			if speed_threshold > 0. and owner.velocity.length() < speed_threshold: return
			attack_node(body, owner.damage_source)
	)

func trigger() -> void:
	attack_overlap(owner.damage_source)

func attack_overlap(source: PlayerData, damage: int = -1) -> int:
	var count = 0
	for area in get_overlapping_bodies():
		if attack_node(area, source, damage):
			count += 1
	return count

func attack_node(node: Node2D, source: PlayerData, damage: int = -1) -> bool:
	if not node.has_method('take_damage'): return false
	if things_hit.has(node): return false
	if node == owner: return false
	if owner is Item and not source: return false
	
	if damage < 0: damage = self.damage
	
	var did_attack := node.call('take_damage', damage, source) as bool
	if did_attack:
		attack.emit(node)
		if remember_hits:
			things_hit.append(node)
		return true
	return false
