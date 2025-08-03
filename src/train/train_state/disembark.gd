# disembark.gd
extends TrainState

var station_data
var previous_karma:int = 0


func enter(data := {}) -> void:
	station_data = data
	
	if station_data.station_index == 0 and KarmaManager.karma + 20 > previous_karma:
		previous_karma = KarmaManager.karma
		train.add_train_car()
	
	train.status_changed.emit("Disembarking at Station %s" % data.station_name)
	train.passengers.try_disembark_passengers(data.station_index)
	train.passengers_disembarked.connect(_on_train_car_disembarked)


func exit() -> void:
	train.passengers_disembarked.disconnect(_on_train_car_disembarked)


func _on_train_car_disembarked() -> void:
	finished.emit(BOARD, station_data)
