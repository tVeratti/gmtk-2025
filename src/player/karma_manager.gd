extends Node


signal karma_gained(amount:int)
signal karma_target_changed(value:int)


const TARGET_MULTIPLIER:int = 6


var karma:int = 0
var karma_target:int = 20


func gain_karma(amount:int) -> void:
	karma += amount
	karma_gained.emit(amount)


func adjust_target() -> void:
	var num_cars:int = get_tree().get_nodes_in_group("train_car").size()
	var upgrades:int = 0
	while karma >= karma_target:
		karma_target = _get_target_karma(num_cars)
		num_cars += 1
		upgrades += 1
		
	KarmaManager.karma_target_changed.emit(upgrades)


func _get_target_karma(num_cars:int) -> int:
	return karma_target + (num_cars * 4 * TARGET_MULTIPLIER)
