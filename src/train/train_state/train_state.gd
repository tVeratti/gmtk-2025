class_name TrainState
extends State


const IDLE: = "Idle"
const BOARD: = "Board"
const DISEMBARK: = "Disembark"
const TRANSIT: = "Transit"
const STOP: = "Stop"


@onready var train:Train = owner


func _station_to_dictionary(station:Station) -> Dictionary:
	return {
		"station_index": station.index,
		"station_name": station.station_name,
		"track_position": station.track_position
	}


func _get_next_index(previous_station_index:int) -> int:
	var next_station_index:int = previous_station_index + 1
	if next_station_index > MapManager.stations.size() - 1:
		next_station_index = 0
	
	return next_station_index


## Loop around the 0 index / position to 1.0 to prevent tweens from going backward to 0.0.
func _get_next_position(station:Station) -> float:
	return station.track_position if station.index > 0 else 1.0


func fade_in_audio(stream:AudioStream) -> void:
	train.train_state_audio.stop()
	train.train_state_audio.stream = stream
	train.train_state_audio.play()
	#var tween: = AudioUtility.fade_audio(train.train_state_audio, 1.0, 0.3)
