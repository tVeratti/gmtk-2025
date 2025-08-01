class_name Train
extends Node2D


signal train_cars_ready
signal passengers_boarded
signal passengers_disembarked


const TRAIN_CAR_GAP:float = 30.0
const TRAIN_SPEED_MAX:float = 0.01


@export var train_car_scene = load("uid://q5inrad673eu")
@export var train_car_count:int = 3


@onready var train_cars_root:Node2D = %TrainCars
@onready var passengers:TrainPassengers = %Passengers

@onready var info:Label = %Info


var train_cars:Array = []


func _ready() -> void:
	for i in range(train_car_count):
		_add_train_car()
	
	train_cars_ready.emit()


func _add_train_car() -> void:
	var index = train_cars.size()
	var train_car:TrainCar = train_car_scene.instantiate()
	train_cars_root.add_child(train_car)
	train_car.position.x = -index * (train_car.sprite.texture.get_width() + TRAIN_CAR_GAP)
	train_car.passengers.boarded.connect(_on_train_car_boarded)
	train_car.passengers.disembarked.connect(_on_train_car_disembarked)
	train_cars.append(train_car)


func _on_train_car_boarded(_g) -> void:
	passengers_boarded.emit()


func _on_train_car_disembarked(_g) -> void:
	passengers_disembarked.emit()
