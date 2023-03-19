class_name DamageSource extends RefCounted

var player: Player
func by_player(player: Player) -> DamageSource:
	self.player = player
	return self

var item: Item
func with_item(item: Item) -> DamageSource:
	self.item = item
	return self

var verb: StringName
func by_doing(verb: StringName) -> DamageSource:
	self.verb = verb
	return self

func clone() -> DamageSource:
	var src := DamageSource.new()
	src.player = player
	src.item = item
	src.verb = verb
	return src
