# stop.gd
extends TrainState


var station:Station


func enter(data = {}) -> void:
	print("stop ", data)
	train.info.text = "Approaching Station %s" % data.station_index
	station = MapManager.stations[data.station_index]
	
	MapManager.station_approaching.emit(station)


func update(delta) -> void:
	var next_position = station.track_position if station.index > 0 else 1.0
	var distance:float = abs((next_position) - MapManager.track_position)
	if distance <= 0.01:
		MapManager.train_speed = 0.0
		finished.emit(DISEMBARK, _station_to_dictionary(station))
