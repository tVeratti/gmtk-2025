class_name PlayerController
extends Node


const ACCELERATION:float = 5.0
const DE_ACCELERATION:float = 8.0
const SPEED:float = 500.0


var direction:Vector2 = Vector2.ZERO


@onready var body:CharacterBody2D = owner


func get_velocity(delta):
	direction = get_direction()
	
	var acceleration:float = DE_ACCELERATION
	var target_velocity: = body.velocity
	
	if direction.dot(target_velocity) > 0:
		acceleration = ACCELERATION
	
	var destination:Vector2 = direction.normalized() * SPEED
	target_velocity = target_velocity.lerp(destination, acceleration * delta)
	
	#TODO: use gravity const / jumping
	target_velocity.y += 500
	
	return target_velocity


func get_direction() -> Vector2:
	if Input.is_action_pressed("ui_left"):
		return Vector2.LEFT
	
	if Input.is_action_pressed("ui_right"):
		return Vector2.RIGHT
	
	return Vector2.ZERO
