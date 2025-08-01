class_name GhostTicket
extends Node2D


signal stamped


const POSITION_OFFSET:float = 100.0
const ANIMATION_DURATION:float = 0.5


var player:Player

var is_stamping:bool = false


@onready var sprite_2d:Sprite2D = %Sprite2D
@onready var sprite_material:ShaderMaterial = sprite_2d.material


func _ready() -> void:
	scale = Vector2.ZERO


func animate_in(interacting_player:Player) -> void:
	if is_stamping: return
	
	player = interacting_player
	var direction: = player.global_position.direction_to(global_position)
	
	var tween: = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, ANIMATION_DURATION)
	tween.parallel().tween_property(self, "position:x", direction.x * POSITION_OFFSET, ANIMATION_DURATION)
	tween.parallel().tween_property(self, "position:y", -100.0, ANIMATION_DURATION)
	
	player.player_input.interact.connect(_on_player_interact)


func animate_out() -> void:
	if is_stamping: return
	
	var tween: = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ZERO, ANIMATION_DURATION)
	tween.parallel().tween_property(self, "position", Vector2.ZERO, ANIMATION_DURATION)
	
	player.player_input.interact.disconnect(_on_player_interact)


func animate_stamp() -> void:
	# Block other animations/events while stamping
	is_stamping = true
	
	#sprite_material.set_shader_parameter("strength", 1.0)
	
	var tween: = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(2, 2), 0.2)
	tween.parallel().tween_property(self, "scale", Vector2(1.5, 1.5), 0.2).set_delay(0.2)
	#tween.parallel().tween_method(_tween_shader, 1.0, 0.0, 0.5)
	tween.parallel().tween_property(self, "position:y", -150.0, ANIMATION_DURATION)
	tween.tween_property(self, "modulate:a", 0.0, ANIMATION_DURATION)
	
	player.player_input.interact.disconnect(_on_player_interact)


func _on_player_interact() -> void:
	stamped.emit()
	animate_stamp()


func _tween_shader(value:float) -> void:
	sprite_material.set_shader_parameter("strength", value)
