class_name ParallaxAutoScroller
extends ParallaxLayer


@export var speed:float = 100.0


func _process(delta):
	motion_offset.x += speed * delta
