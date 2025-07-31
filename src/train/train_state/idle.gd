extends TrainState


func enter(data := {}) -> void:
	var first_station = MapManager.stations[0]
	finished.emit(BOARD, _station_to_dictionary(first_station))
