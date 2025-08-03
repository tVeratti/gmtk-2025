# transit.gd
extends TrainState


const TRAVEL_TIME:float = 30.0 # seconds
const BRAKE_TIME:float = 10.0 # seconds
const BRAKE_PERCENTAGE:float = 1.0 - (BRAKE_TIME / TRAVEL_TIME)


var previous_station_index:int
var next_station:Station
var is_stopping:bool = false


func enter(data := {}) -> void:
	is_stopping = false
	previous_station_index = data.station_index
	var next_station_index = _get_next_index(previous_station_index)
	
	next_station = MapManager.stations[next_station_index]
	train.status_changed.emit("Transit to Station %s" % next_station.station_name)
	#train.fmod_tracks["fmod_parameters/train_motion"] = "Start"
	
	var next_position = _get_next_position(next_station)
	# Tween to 90% of the next station, then transition to stopping/braking
	var transit_tween: = get_tree().create_tween()
	transit_tween.set_trans(Tween.TRANS_SINE)
	transit_tween.set_ease(Tween.EASE_IN_OUT)
	transit_tween.tween_property(MapManager, "track_position", next_position, TRAVEL_TIME)
	transit_tween.parallel().tween_method(_tween_state, 0.0, 1.0, TRAVEL_TIME)
	transit_tween.tween_callback(func():
		# NOTE: `_tween_state` will have transitioned to STOP before the end of this tween
		# Order stays: TRANNSIT -> STOP -> DISEMBARK
		MapManager.track_position = next_station.track_position
		finished.emit(DISEMBARK, _station_to_dictionary(next_station)))
	
	AudioUtility.fade_audio(train.train_audio, 0.0, 3.0)
	train.train_start_audio.volume_db = 0.0
	train.train_start_audio.play()
	
	await get_tree().create_timer(3.0).timeout
	AudioUtility.fade_audio(train.train_start_audio, -80, 2.0)


func _tween_state(percentage:float) -> void:
	if not is_stopping and percentage > BRAKE_PERCENTAGE:
		is_stopping = true
		finished.emit(STOP, _station_to_dictionary(next_station))
