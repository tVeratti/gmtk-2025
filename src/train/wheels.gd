extends Node2D


const SPEED:float = 150.0


@onready var wheel_1:Sprite2D = %Wheel1
@onready var wheel_2:Sprite2D = %Wheel2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	wheel_1.rotation = MapManager.track_position * PI * SPEED
	wheel_2.rotation = MapManager.track_position * PI * SPEED
