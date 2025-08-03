class_name GhostTicket
extends Node2D


signal stamped


const POSITION_OFFSET:float = 80.0
const SHOW_ANIMATION_DURATION:float = 0.5
const STAMP_ANIMATION_DURATION:float = 1.0


var player:Player

var is_stamping:bool = false

var ticket_tween:Tween


@onready var visual_root:Node2D = %VisualRoot
@onready var ticket_sprite_2d:Sprite2D = %Ticket
@onready var sprite_material:ShaderMaterial = ticket_sprite_2d.material
@onready var stamp_sprite_2d:Sprite2D = %Stamp
@onready var fmod_stamp:FmodEventEmitter2D = %FmodStamp


func _ready() -> void:
	visual_root.scale = Vector2.ZERO


func animate_in(interacting_player:Player) -> void:
	if is_stamping: return
	
	player = interacting_player
	var direction: = player.global_position.direction_to(global_position)
	
	if ticket_tween and ticket_tween.is_running():
		ticket_tween.kill()
	
	ticket_tween = get_tree().create_tween()
	ticket_tween.set_trans(Tween.TRANS_QUART)
	ticket_tween.set_ease(Tween.EASE_OUT)
	ticket_tween.tween_property(visual_root, "scale", Vector2.ONE, SHOW_ANIMATION_DURATION)
	ticket_tween.parallel().tween_property(visual_root, "position:x", direction.x * POSITION_OFFSET, SHOW_ANIMATION_DURATION)
	ticket_tween.parallel().tween_property(visual_root, "position:y", -100.0, SHOW_ANIMATION_DURATION)
	
	player.player_input.interact.connect(_on_player_interact)


func animate_out() -> void:
	if is_stamping: return
	
	if ticket_tween and ticket_tween.is_running():
		ticket_tween.kill()
		
	ticket_tween = get_tree().create_tween()
	ticket_tween.set_trans(Tween.TRANS_QUART)
	ticket_tween.set_ease(Tween.EASE_OUT)
	ticket_tween.tween_property(visual_root, "scale", Vector2.ZERO, SHOW_ANIMATION_DURATION)
	ticket_tween.parallel().tween_property(visual_root, "position", Vector2.ZERO, SHOW_ANIMATION_DURATION)
	
	player.player_input.interact.disconnect(_on_player_interact)


func animate_stamp() -> void:
	# Block other animations/events while stamping
	is_stamping = true
	fmod_stamp.play_one_shot()
	
	#sprite_material.set_shader_parameter("strength", 1.0)
	
	if ticket_tween and ticket_tween.is_running():
		ticket_tween.kill()
	
	# Animate the ticket sprite
	ticket_tween = get_tree().create_tween()
	ticket_tween.set_trans(Tween.TRANS_QUART)
	ticket_tween.set_ease(Tween.EASE_OUT)
	ticket_tween.tween_property(visual_root, "scale", Vector2(2, 2), 0.2)
	ticket_tween.parallel().tween_property(visual_root, "scale", Vector2(1.5, 1.5), 0.2).set_delay(0.2)
	#tween.parallel().tween_method(_tween_shader, 1.0, 0.0, 0.5)
	ticket_tween.parallel().tween_property(visual_root, "position:y", -150.0, STAMP_ANIMATION_DURATION)
	ticket_tween.tween_property(visual_root, "self_modulate:a", 0.0, STAMP_ANIMATION_DURATION)
	
	# Animate the stamp sprite
	var tween_stamp: = get_tree().create_tween()
	tween_stamp.tween_property(stamp_sprite_2d, "position", Vector2(5, -5), 0.2)
	tween_stamp.parallel().tween_property(stamp_sprite_2d, "scale", Vector2(0.3, 0.3), 0.2)
	tween_stamp.parallel().tween_property(stamp_sprite_2d, "modulate:a", 1.0, 0.1)
	
	player.player_input.interact.disconnect(_on_player_interact)


func _on_player_interact() -> void:
	stamped.emit()
	animate_stamp()


func _tween_shader(value:float) -> void:
	sprite_material.set_shader_parameter("strength", value)
