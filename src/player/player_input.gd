class_name PlayerInput
extends Node


signal interact


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		interact.emit()
