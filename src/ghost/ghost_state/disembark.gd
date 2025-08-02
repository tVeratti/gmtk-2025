# disembark.gd
extends GhostState


func enter(_data := {}) -> void:
	ghost.set_standing()
	
	var delay:float = randf_range(0.0, 1.0)
	var tween: = get_tree().create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, 2.0).set_delay(delay)
	tween.parallel().tween_property(ghost, "position:y", -10, 2.0).as_relative()
	tween.tween_callback(func():
		ghost.disembarked.emit(ghost)
		ghost.queue_free())
