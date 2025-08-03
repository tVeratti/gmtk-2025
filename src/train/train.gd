class_name Train
extends Node2D


signal train_cars_ready
signal passengers_boarded
signal passengers_disembarked
signal status_changed(info:String)

signal train_car_entered
signal train_car_exited


const TRAIN_CAR_GAP:float = 30.0
const TRAIN_SPEED_MAX:float = 0.01


@export var train_car_scene = load("uid://q5inrad673eu")
@export var train_car_count:int = 3


@onready var train_cars_root:Node2D = %TrainCars
@onready var passengers:TrainPassengers = %Passengers

@onready var fmod_tracks:FmodEventEmitter2D = %"Fmod-Tracks"
@onready var fmod_inside_snapshot:FmodEventEmitter2D = %"Fmod-InsideSnapshot"


@onready var info:Label = %Info


var train_cars:Array = []


func _ready() -> void:
	for i in range(train_car_count):
		_add_train_car()
	
	train_cars_ready.emit()


func _add_train_car() -> void:
	var index = train_cars.size()
	var train_car:TrainCar = train_car_scene.instantiate()
	train_car.train = self
	train_cars_root.add_child(train_car)
	train_car.position.x = -index * (train_car.texture_size + TRAIN_CAR_GAP)
	train_cars.append(train_car)


func _on_passengers_train_passengers_boarded():
	passengers_boarded.emit()


func _on_passengers_train_passengers_disembarked():
	passengers_disembarked.emit()


func _on_train_car_entered():
	var tween: = get_tree().create_tween()
	tween.tween_property(fmod_inside_snapshot, "fmod_parameters/inside", 1.0, 0.2)


func _on_train_car_exited():
	var tween: = get_tree().create_tween()
	tween.tween_property(fmod_inside_snapshot, "fmod_parameters/inside", 0.0, 0.1)
