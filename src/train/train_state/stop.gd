# stop.gd
extends TrainState


const BRAKE_TIME:float = 10.0 # seconds


var station:Station


func enter(data = {}) -> void:
	train.status_changed.emit("Approaching Station %s" % data.station_name)
	train.fmod_tracks["fmod_parameters/train_motion"] = "Stop"
	station = MapManager.stations[data.station_index]
	
	MapManager.station_approaching.emit(station)
