class_name PlayerIdle
extends PlayerState


func enter(_data := {}) -> void:
	player.animated_sprite_2d.play("idle")


func update(_delta: float) -> void:
	if not player.player_controller.direction.is_zero_approx():
		finished.emit(MOVE)
