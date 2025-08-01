# board.gd
extends GhostState


func enter(_data := {}) -> void:
	ghost.set_standing()
	
	ghost.position.y = -10
	
	var delay: = randf_range(0.0, 4.0)
	var tween: = get_tree().create_tween()
	tween.tween_property(ghost, "modulate:a", 1.0, 1.0).set_delay(delay)
	tween.parallel().tween_property(ghost, "position:y", 0.0, 1.0)
	tween.tween_callback(func():
		ghost.boarded.emit(ghost)
		finished.emit(SIT))
