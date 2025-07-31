# stop.gd
extends TrainState


const BRAKE_STRENGTH: = 0.01


var station:Station


func enter(data = {}) -> void:
	print("stop ", data)
	train.info.text = "Approaching Station %s" % data.station_index
	station = MapManager.stations[data.station_index]


func update(delta) -> void:
	var next_position = station.track_position if station.index > 0 else 1.0
	var distance:float = abs(next_position - MapManager.track_position)
	if distance > 0.001:
		var brake_strength:float = BRAKE_STRENGTH
		MapManager.train_speed = lerp(MapManager.train_speed, 0.0, brake_strength * delta)
	else:
		MapManager.train_speed = 0.0
		finished.emit(DISEMBARK, _station_to_dictionary(station))
