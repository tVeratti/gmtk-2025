class_name Ghost
extends Node


var id:String = UUID.v4_short()

## Station index where the ghost got on the train
var start_station_index:int

## Station index where the ghost wants to get off the train
var stop_station_index:int

## If not `null`, prevents the ghost from getting off the train at their `destination`
var blocker:Blocker


func can_disembark(station_index:int) -> bool:
	if station_index < stop_station_index:
		return false
	
	return not blocker or blocker.is_solved
