class_name TrainPassengers
extends Node


@export var ghost_scene = load("uid://5aa0f3kbnxk3")


@onready var train:Train = owner


## Try boarding a number of new passengers checking all train cars for capacity.
func try_board_passengers(amount:int, station_index:int) -> void:
	var cars_with_capacity:Array = train.train_cars.filter(
		func(car:TrainCar):
			return car.passengers.has_capacity())
	
	if cars_with_capacity.is_empty():
		return
	
	var new_ghosts: = Array()
	for i in range(amount):
		var ghost: = _create_ghost_passenger(station_index)
		new_ghosts.append(ghost)
	
	var train_car:TrainCar = cars_with_capacity.pop_back()
	while not new_ghosts.is_empty():
		var overflow:Array = train_car.passengers.try_board_passengers(new_ghosts)
		if not overflow.is_empty():
			if cars_with_capacity.is_empty():
				# No more cars with capacity
				break
			else:
				# Try adding passengers to the next train car
				train_car = cars_with_capacity.pop_back()


## Check each train car for passengers that can disembark.
func try_disembark_passengers(station_index:int) -> void:
	for train_car in owner.train_cars:
		train_car.passengers.check_passengers_disembarking(station_index)


func _create_ghost_passenger(station_index:int) -> Ghost:
	var num_stations:int = MapManager.stations.size()
	var ghost:Ghost = ghost_scene.instantiate()
	ghost.start_station_index = station_index
	
	var delta:int = (randi() % (num_stations - 1)) + 1
	ghost.stop_station_index = (station_index + delta) % num_stations
	
	return ghost
