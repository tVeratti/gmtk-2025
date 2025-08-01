# disembark.gd
extends GhostState


func enter(_data := {}) -> void:
	ghost.set_standing()
	
	# TODO: Animate disembarking?
	await get_tree().create_timer(2.0).timeout
	ghost.disembarked.emit(ghost)
	ghost.queue_free()


func update(_delta) -> void:
	# animate off seat
	pass
