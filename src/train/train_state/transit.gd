# transit.gd
extends TrainState


const ACCELERATION:float = 1.0


var previous_station_index:int
var next_station_index:int


func enter(data := {}) -> void:
	previous_station_index = data.station_index
	next_station_index = previous_station_index + 1
	if next_station_index > MapManager.stations.size() - 1:
		next_station_index = 0
	
	print("transit ", next_station_index)
	train.info.text = "Transit to Station %s" % next_station_index


func update(delta):
	_accelerate(delta)
	
	_check_station_proximity()


func _accelerate(delta:float) -> void:
	if MapManager.train_speed < Train.TRAIN_SPEED_MAX:
		MapManager.train_speed = lerp(MapManager.train_speed, Train.TRAIN_SPEED_MAX, ACCELERATION * delta)


func _check_station_proximity() -> void:
	var track_position: = MapManager.track_position
	var next_station:Station = MapManager.stations[next_station_index]
	
	var next_position = next_station.track_position if next_station_index > 0 else 1.0
	var distance:float = abs(next_position - track_position)
	if distance < 0.1:
		finished.emit(STOP, _station_to_dictionary(next_station))
