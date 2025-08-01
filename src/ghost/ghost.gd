class_name Ghost
extends Node


var id:String = UUID.v4_short()

## Station index where the ghost got on the train
var start_station_index:int
## Station index where the ghost wants to get off the train
var stop_station_index:int
## Whether the ghost has had their ticket stamped
var ticket_stamped:bool = false
## If not `null`, prevents the ghost from getting off the train at their `destination`
var blocker:Blocker
## If a ghost is blocked at its target station, flag it to allow disembarking at any future station.
var has_missed_station:bool = false


@onready var ticket:GhostTicket = %GhostTicket
@onready var destination_label:Label = %Destination


func _ready() -> void:
	destination_label.text = "Destination: %s" % stop_station_index


func can_disembark(station_index:int) -> bool:
	if station_index != stop_station_index and not has_missed_station:
		return false
	
	var is_not_blocked:bool = not blocker or blocker.is_solved
	if is_not_blocked and ticket_stamped:
		return true
	else:
		# The ghost wanted to disembark at this station but was blocked
		has_missed_station = true
		return false


func _on_interact_area_body_entered(body):
	if not ticket_stamped:
		ticket.animate_in(body)


func _on_interact_area_body_exited(body):
	ticket.animate_out()


func _on_ghost_ticket_stamped():
	ticket_stamped = true
