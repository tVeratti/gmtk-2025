class_name TrainCar
extends Node2D


@export var texture_size:int = 1128 + 122 + 40
@export var capacity:int = 4
@export var comfort:int = 1


var train:Train
var open_seats:Array = []


@onready var passengers:TrainCarPassengers = %Passengers
@onready var sprite:Sprite2D = %Main
@onready var capacity_label:Label = %Capacity
@onready var seats_root:Node2D = $Seats
@onready var wall_left:CollisionShape2D = %WallLeft


func _ready() -> void:
	open_seats = seats_root.get_children()
	
	passengers.boarded.connect(_on_passengers_boarded)
	passengers.disembarked.connect(_on_passengers_disembarked)
	
	_update_capacity_label()


func set_is_last(value:bool) -> void:
	wall_left.disabled = !value


func add_ghosts_to_seats(ghosts:Array) -> void:
	for g in ghosts:
		var seat:Node2D = open_seats.pop_back()
		seat.add_child(g)
		if seat.is_in_group("flip_seat"):
			g.sprite_2d.flip_h = true


func _on_passengers_disembarked(ghosts) -> void:
	for g in ghosts:
		var seat:Node2D = g.get_parent()
		open_seats.append(seat)
	
	_update_capacity_label()


func _on_passengers_boarded(_ghosts) -> void:
	_update_capacity_label()


func _update_capacity_label() -> void:
	capacity_label.text = "Capacity %s/%s" % [passengers.ghosts.size(), capacity]


func _on_inside_area_body_entered(body):
	train.train_car_entered.emit()


func _on_inside_area_body_exited(body):
	train.train_car_exited.emit()
