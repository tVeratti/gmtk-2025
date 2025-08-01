# sit.gd
extends GhostState


func enter(_data := {}) -> void:
	ghost.set_sitting()
	ghost.disembarking.connect(_on_disembark)


func exit() -> void:
	ghost.disembarking.disconnect(_on_disembark)


func _on_disembark() -> void:
	finished.emit(DISEMBARK)
