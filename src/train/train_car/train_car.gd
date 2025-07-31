class_name TrainCar
extends Node2D


@export var capacity:int = 4
@export var comfort:int = 1


@onready var passengers:TrainCarPassengers = %Passengers
@onready var sprite:Sprite2D = $Sprite
@onready var capacity_label:Label = %Capacity


func _ready() -> void:
	passengers.boarded.connect(_on_passengers_boarded)
	passengers.disembarked.connect(_on_passengers_disembarked)
	
	_update_capacity_label()


func _on_passengers_disembarked(_g) -> void:
	_update_capacity_label()


func _on_passengers_boarded(_g) -> void:
	_update_capacity_label()


func _update_capacity_label() -> void:
	capacity_label.text = "Capacity %s/%s" % [passengers.ghosts.size(), capacity]
