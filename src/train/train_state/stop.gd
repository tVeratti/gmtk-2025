# stop.gd
extends TrainState


const BRAKE_TIME:float = 10.0 # seconds


var station:Station


func enter(data = {}) -> void:
	train.info.text = "Approaching Station %s" % data.station_index
	train.fmod_tracks["fmod_parameters/train_motion"] = "Stop"
	station = MapManager.stations[data.station_index]
	
	MapManager.station_approaching.emit(station)
