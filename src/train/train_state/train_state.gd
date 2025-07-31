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
		"num_boarders": station.num_boarders,
		"track_position": station.track_position
	}
