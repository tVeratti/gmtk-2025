class_name Player
extends CharacterBody2D


signal render_scroll_text(text:String)


@onready var state:Label = %State
@onready var player_input:PlayerInput = %PlayerInput
@onready var player_controller:PlayerController = %PlayerController
@onready var state_machine:StateMachineComponent = %StateMachineComponent
@onready var scroll_text_component:ScrollTextComponent = %ScrollTextComponent

@onready var visual_root:Node2D = %VisualRoot
@onready var animated_sprite_2d:AnimatedSprite2D = %AnimatedSprite2D


func _ready() -> void:
	KarmaManager.karma_gained.connect(_on_karma_gained)
	render_scroll_text.connect(_on_render_scroll_text)


func _process(_delta):
	state.text = state_machine.state.name


func _physics_process(delta):
	velocity = player_controller.get_velocity(delta)
	move_and_slide()


func _on_render_scroll_text(text:String) -> void:
	scroll_text_component.render(text)


func _on_karma_gained(amount:int) -> void:
	_on_render_scroll_text("+%s Karma" % amount)
