class_name PlayerIdle
extends PlayerState


func update(_delta: float) -> void:
	if not player.player_controller.direction.is_zero_approx():
		finished.emit(MOVE)
