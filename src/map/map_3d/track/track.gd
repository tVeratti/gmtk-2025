class_name Track
extends Node3D


@onready var path_3d:Path3D = %Path3D
@onready var path_follow_3d:PathFollow3D = %PathFollow3D


func _process(_delta):
	path_follow_3d.progress_ratio = -MapManager.track_position
