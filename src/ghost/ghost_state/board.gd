# board.gd
extends GhostState


func enter(_data := {}) -> void:
	ghost.set_standing()
	
	 #TODO: Animate boarding?
	await get_tree().create_timer(2.0).timeout
	ghost.boarded.emit(ghost)
	finished.emit(SIT)


func update(_delta) -> void:
	pass
	# move to seat
