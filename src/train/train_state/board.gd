# board.gd
extends TrainState


var station_data


func enter(data := {}) -> void:
	station_data = data
	train.status_changed.emit("Boarding %s at Station %s" % [data.num_boarders, data.station_name])
	train.passengers_boarded.connect(_on_train_car_boarded)
	
	train.passengers.try_board_passengers(
		data.num_boarders,
		data.station_index)


func exit() -> void:
	train.passengers_boarded.disconnect(_on_train_car_boarded)


func _on_train_car_boarded() -> void:
	finished.emit(TRANSIT, station_data)
