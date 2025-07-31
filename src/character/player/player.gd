class_name Player
extends CharacterBody2D


@onready var state:Label = %State
@onready var player_controller:PlayerController = %PlayerController
@onready var state_machine:StateMachineComponent = %StateMachineComponent
@onready var visual_root:Node2D = %VisualRoot
@onready var animated_sprite_2d:AnimatedSprite2D = $VisualRoot/AnimatedSprite2D



func _process(delta):
	state.text = state_machine.state.name


func _physics_process(delta):
	velocity = player_controller.get_velocity(delta)
	move_and_slide()
