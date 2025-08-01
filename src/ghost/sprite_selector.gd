class_name GhostSpriteSelector
extends Node


const LOAD_PATH:String = "res://ghost/assets/ghost_%s/ghost_%s_%s.png"


@export var available_types:Array[String] = [
	"a", "b", "c", "d", "e", "f", "g"
]


func get_random_sprites() -> Array:
	var type:String = available_types.pick_random()
	return load_sprites(type)


func load_sprites(type:String) -> Array:
	var sit_sprite: = load(LOAD_PATH % [type, type, "sit"])
	var stand_sprite: = load(LOAD_PATH % [type, type, "stand"])
	
	return [sit_sprite, stand_sprite]
