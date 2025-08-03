class_name ScrollTextComponent
extends Node2D


@export var scroll_text_scene:PackedScene = load("uid://bkkhdaokiiobq")


var queue:Dictionary[String, Array] = {}


func render(text:String, at_position:Vector2 = global_position) -> void:
	var id: = UUID.v4_short()
	if queue.is_empty():
		_render_text(id, text, at_position)
	
	queue[id] =[text, at_position]


func _render_text(id:String, text:String, at_position:Vector2) -> void:
	var scroll_text_node:ScrollText = scroll_text_scene.instantiate()
	scroll_text_node.text = text
	#scroll_text_node.top_level = true
	scroll_text_node.half_done.connect(_on_half_done.bind(id, text, at_position))
	call_deferred("_add_text_child", id, scroll_text_node, at_position)


func _add_text_child(id:String, scroll_text_node:ScrollText, at_position:Vector2) -> void:
	add_child(scroll_text_node)
	#scroll_text_node.global_position = at_position


func _on_half_done(id, text, at_position) -> void:
	queue.erase(id)
	
	if not queue.is_empty():
		var queued_id = queue.keys()[0]
		var queued_value = queue[queued_id]
		_render_text(queued_id, queued_value[0], queued_value[1])
