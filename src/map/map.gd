extends Node2D


@onready var map_3d:Map3D = %Map3D
@onready var train:Train = %Train
@onready var player:Player = %Player




var loop_progress:float = 0.0


func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	player.global_position = train.train_cars[0].global_position + Vector2(300, 300)
