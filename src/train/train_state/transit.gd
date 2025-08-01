# transit.gd
extends TrainState


const TRAVEL_TIME:float = 30.0 # seconds

var previous_station_index:int
var next_station_index:int


func enter(data := {}) -> void:
	previous_station_index = data.station_index
	next_station_index = previous_station_index + 1
	if next_station_index > MapManager.stations.size() - 1:
		next_station_index = 0
	
	var next_station:Station = MapManager.stations[next_station_index]
	var next_position = next_station.track_position if next_station_index > 0 else 1.0
	train.info.text = "Transit to Station %s" % next_station_index
	print("transit ", next_station_index)
	
	var transit_tween: = get_tree().create_tween()
	transit_tween.set_trans(Tween.TRANS_QUAD)
	transit_tween.set_ease(Tween.EASE_IN_OUT)
	transit_tween.tween_property(MapManager, "track_position", next_position, TRAVEL_TIME)
	transit_tween.tween_callback(func():
		MapManager.track_position = next_station.track_position
		finished.emit(DISEMBARK, _station_to_dictionary(next_station)))
