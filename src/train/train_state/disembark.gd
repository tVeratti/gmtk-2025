# disembark.gd
extends TrainState

var station_data

func enter(data := {}) -> void:
	station_data = data
	train.info.text = "Disembarking at Station %s" % data.station_name
	train.passengers.try_disembark_passengers(data.station_index)
	train.passengers_disembarked.connect(_on_train_car_disembarked)


func exit() -> void:
	train.passengers_disembarked.disconnect(_on_train_car_disembarked)


func _on_train_car_disembarked() -> void:
	finished.emit(BOARD, station_data)
