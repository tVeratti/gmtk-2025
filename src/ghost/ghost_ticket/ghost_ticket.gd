class_name GhostTicket
extends Node2D


signal stamped


const POSITION_OFFSET:float = 80.0
const SHOW_ANIMATION_DURATION:float = 0.5
const STAMP_ANIMATION_DURATION:float = 1.0

const STAMP_DISTANCE_GOOD:float = 30.0
const STAMP_DISTANCE_GREAT:float = 20.0
const STAMP_DISTANCE_PERFECT:float = 10.0


var player:Player

var is_stamping:bool = false
var is_stamped:bool = false

var ticket_tween:Tween


@onready var visual_root:Node2D = %VisualRoot
@onready var ticket_sprite_2d:Sprite2D = %Ticket
@onready var sprite_material:ShaderMaterial = ticket_sprite_2d.material
@onready var stamp_sprite_2d:Sprite2D = %Stamp
@onready var fmod_stamp:FmodEventEmitter2D = %FmodStamp
@onready var scroll_text_component:ScrollTextComponent = %ScrollTextComponent
@onready var animation_player:AnimationPlayer = %AnimationPlayer
@onready var inner:Sprite2D = %Inner
@onready var station_label:Label = %Station


func _ready() -> void:
	ticket_sprite_2d.scale = Vector2.ZERO
	station_label.text = str(MapManager.stations[owner.stop_station_index].station_name)


func animate_in(interacting_player:Player) -> void:
	if is_stamping: return
	
	player = interacting_player
	var direction: = player.global_position.direction_to(global_position)
	
	if ticket_tween and ticket_tween.is_running():
		ticket_tween.kill()
	
	stamp_sprite_2d.show()
	ticket_tween = get_tree().create_tween()
	ticket_tween.set_trans(Tween.TRANS_QUART)
	ticket_tween.set_ease(Tween.EASE_OUT)
	ticket_tween.tween_property(ticket_sprite_2d, "scale", Vector2(0.8, 0.8), SHOW_ANIMATION_DURATION)
	ticket_tween.parallel().tween_property(visual_root, "position:x", direction.x * POSITION_OFFSET, SHOW_ANIMATION_DURATION)
	ticket_tween.parallel().tween_property(visual_root, "position:y", -100.0, SHOW_ANIMATION_DURATION)
	
	if not is_stamped:
		player.player_input.interact.connect(_on_player_interact)


func animate_out() -> void:
	if is_stamping: return
	
	if ticket_tween and ticket_tween.is_running():
		ticket_tween.kill()
	
	stamp_sprite_2d.hide()
	
	ticket_tween = get_tree().create_tween()
	ticket_tween.set_trans(Tween.TRANS_QUART)
	ticket_tween.set_ease(Tween.EASE_OUT)
	ticket_tween.tween_property(ticket_sprite_2d, "scale", Vector2.ZERO, SHOW_ANIMATION_DURATION)
	ticket_tween.parallel().tween_property(visual_root, "position", Vector2.ZERO, SHOW_ANIMATION_DURATION)
	
	if not is_stamped:
		player.player_input.interact.disconnect(_on_player_interact)


func animate_stamp() -> void:
	# Block other animations/events while stamping
	is_stamped = true
	is_stamping = true
	fmod_stamp.play_one_shot()
	animation_player.stop(true)
	inner.show()
	
	#sprite_material.set_shader_parameter("strength", 1.0)
	
	if ticket_tween and ticket_tween.is_running():
		ticket_tween.kill()
	
	# Animate the ticket sprite
	ticket_tween = get_tree().create_tween()
	ticket_tween.set_trans(Tween.TRANS_QUART)
	ticket_tween.set_ease(Tween.EASE_OUT)
	ticket_tween.tween_property(ticket_sprite_2d, "scale", Vector2(1.2, 1.2), 0.2)
	ticket_tween.parallel().tween_property(ticket_sprite_2d, "scale", Vector2(1.0, 1.0), 0.2).set_delay(0.2)
	#tween.parallel().tween_method(_tween_shader, 1.0, 0.0, 0.5)
	ticket_tween.parallel().tween_property(visual_root, "position:y", -150.0, STAMP_ANIMATION_DURATION)
	ticket_tween.tween_property(visual_root, "self_modulate:a", 0.0, STAMP_ANIMATION_DURATION)
	ticket_tween.tween_callback(func():
		ticket_sprite_2d.scale = Vector2.ZERO
		stamp_sprite_2d.hide()
		stamp_sprite_2d.self_modulate.a = 0.0
		visual_root.self_modulate.a = 1.0
		is_stamping = false
		animate_out())
	
	# Animate the stamp sprite
	var stamp_distance = stamp_sprite_2d.position.length()
	var score_text:String = "Ok"
	var score_value:int = 1
	if stamp_distance <= STAMP_DISTANCE_PERFECT:
		score_text = "PERFECT!"
		score_value = 10
	elif stamp_distance <= STAMP_DISTANCE_GREAT:
		score_text = "Great!"
		score_value = 5
	elif stamp_distance <= STAMP_DISTANCE_GOOD:
		score_text = "Good"
		score_value = 2
	
	scroll_text_component.render(score_text)
	
	var tween_stamp: = get_tree().create_tween()
	tween_stamp.tween_property(stamp_sprite_2d, "scale", Vector2.ONE, 0.2)
	tween_stamp.parallel().tween_property(stamp_sprite_2d, "scale", Vector2(0.8, 0.8), 0.2)
	
	player.player_input.interact.disconnect(_on_player_interact)
	
	await get_tree().create_timer(0.2).timeout
	KarmaManager.gain_karma(score_value)


func _on_player_interact() -> void:
	stamped.emit()
	animate_stamp()


func _tween_shader(value:float) -> void:
	sprite_material.set_shader_parameter("strength", value)
