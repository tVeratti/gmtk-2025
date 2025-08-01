class_name TrainCar
extends Node2D


@export var capacity:int = 4
@export var comfort:int = 1


var open_seats:Array = []


@onready var passengers:TrainCarPassengers = %Passengers
@onready var sprite:Sprite2D = $Sprite
@onready var capacity_label:Label = %Capacity
@onready var seats_root:Node2D = $Seats


func _ready() -> void:
	open_seats = seats_root.get_children()
	
	passengers.boarded.connect(_on_passengers_boarded)
	passengers.disembarked.connect(_on_passengers_disembarked)
	
	_update_capacity_label()


func _on_passengers_disembarked(ghosts) -> void:
	for g in ghosts:
		var seat:Node2D = g.get_parent()
		open_seats.append(seat)
		g.queue_free()
	
	_update_capacity_label()


func _on_passengers_boarded(ghosts) -> void:
	for g in ghosts:
		var seat = open_seats.pop_back()
		seat.add_child(g)
	
	_update_capacity_label()


func _update_capacity_label() -> void:
	capacity_label.text = "Capacity %s/%s" % [passengers.ghosts.size(), capacity]
