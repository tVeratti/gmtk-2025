class_name ParallaxAutoScroller
extends ParallaxLayer


@export var speed:float = 100.0


func _process(delta):
	var speed_percentage:float = MapManager.train_speed / Train.TRAIN_SPEED_MAX if MapManager.train_speed != 0 else 0
	motion_offset.x += speed_percentage * speed * delta
