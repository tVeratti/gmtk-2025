# board.gd
extends TrainState


var station_data


func enter(data := {}) -> void:
	station_data = data
	train.info.text = "Boarding (%s) at Station %s" % [data.num_boarders, data.station_name]
	train.passengers.try_board_passengers(
		data.num_boarders,
		data.station_index)
	
	train.passengers_boarded.connect(_on_train_car_disembarked)


func exit() -> void:
	train.passengers_boarded.disconnect(_on_train_car_disembarked)


func _on_train_car_disembarked() -> void:
	finished.emit(TRANSIT, station_data)
