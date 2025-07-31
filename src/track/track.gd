class_name Track
extends Node3D


const SPEED:float = 0.001


@onready var path_follow_3d = %PathFollow3D


func _process(delta):
	path_follow_3d.progress_ratio -= SPEED * delta
