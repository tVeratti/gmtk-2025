extends Node2D


const TRACK_SPEED:float = 0.001


@onready var map_3d:Map3D = %Map3D
@onready var train:Train = %Train
@onready var player:Player = %Player


var loop_progress:float = 0.0


func _ready() -> void:
	player.global_position = train.train_cars[0].global_position + Vector2(300, 300)


func _process(delta):
	loop_progress += TRACK_SPEED * delta
	
	map_3d.track.path_follow_3d.progress_ratio = -loop_progress
