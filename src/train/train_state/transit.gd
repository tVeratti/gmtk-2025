# transit.gd
extends TrainState


const TRAVEL_TIME:float = 30.0 # seconds
const BRAKE_TIME:float = 10.0 # seconds
const BRAKE_PERCENTAGE:float = 1.0 - (BRAKE_TIME / TRAVEL_TIME)


var previous_station_index:int
var next_station:Station


func enter(data := {}) -> void:
	previous_station_index = data.station_index
	var next_station_index = previous_station_index + 1
	if next_station_index > MapManager.stations.size() - 1:
		next_station_index = 0
	
	next_station = MapManager.stations[next_station_index]
	var next_position = _get_next_position(next_station)
	
	train.info.text = "Transit to Station %s" % next_station_index
	
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


func _tween_state(percentage:float) -> void:
	if percentage > BRAKE_PERCENTAGE:
		finished.emit(STOP, _station_to_dictionary(next_station))
