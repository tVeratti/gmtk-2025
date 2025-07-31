class_name PlayerMove
extends PlayerState


func enter(_data := {}) -> void:
	player.animated_sprite_2d.play("walk")


func update(_delta: float) -> void:
	var direction: = player.player_controller.direction
	
	if direction.is_zero_approx():
		finished.emit(IDLE)
	else:
		player.visual_root.scale.x = 1 if direction.x > 0 else -1
