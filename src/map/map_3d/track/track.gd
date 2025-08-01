class_name Track
extends Node3D


const SPEED_MULTIPLIER:float = 60.0


@onready var path_3d:Path3D = %Path3D
@onready var path_follow_3d:PathFollow3D = %PathFollow3D


func _process(_delta):
	var previous_position: = path_follow_3d.progress_ratio
	path_follow_3d.progress_ratio = -MapManager.track_position
	
	var speed = (previous_position - path_follow_3d.progress_ratio) * SPEED_MULTIPLIER
	MapManager.train_speed = speed
