extends Node


signal karma_gained(amount:int)
signal karma_spent(amount:int)



var karma:int = 0


func gain_karma(amount:int) -> void:
	karma += amount
	karma_gained.emit(amount)
