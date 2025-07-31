extends Node2D


const TRACK_SPEED:float = 0.001


@onready var map_3d:Map3D = %Map3D


var loop_progress:float = 0.0


func _process(delta):
	loop_progress += TRACK_SPEED * delta
	
	map_3d.track.path_follow_3d.progress_ratio = -loop_progress
