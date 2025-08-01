# idle.gd
extends GhostState


func enter(_data := {}) -> void:
	ghost.modulate.a = 0.0
	ghost.set_standing()
	ghost.boarding.connect(_on_boarding)


func exit() -> void:
	ghost.boarding.disconnect(_on_boarding)


func _on_boarding() -> void:
	finished.emit(BOARD)
