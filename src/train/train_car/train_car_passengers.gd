class_name TrainCarPassengers
extends Node


signal disembarked(g:Array)
signal boarded(g:Array)


var ghosts:Array = []

# Tracking when ghosts have successfully boarded
var boarding:Array = []
var awaiting_boarding:Array = []

# Tracking when ghosts have successfully disembarked
var disembarking:Array = []
var awaiting_disembark:Array = []


@onready var train_car:TrainCar = owner
@onready var capacity:int = owner.capacity


## Check all passengers for valid disembarking status and remove them.
func check_passengers_disembarking(station_index:int) -> void:
	disembarking = []
	
	for ghost in ghosts:
		if ghost is Ghost:
			if ghost.can_disembark(station_index):
				disembarking.append(ghost)
				awaiting_disembark.append(ghost)
				ghost.disembarked.connect(_on_ghost_disembarked)
				ghost.disembarking.emit()
	
	if not disembarking.is_empty():
		# Remove disembarking passengers from the array
		ghosts = ghosts.filter(func(g): return not disembarking.has(g))
		
		disembarked.emit(disembarking)


## Determine if there is any capacity for new passengers.
func has_capacity() -> bool:
	return ghosts.size() < capacity


## Board as many passengers as possible into this car, return overflow passengers.
func try_board_passengers(new_ghosts:Array) -> Array:
	boarding = []
	
	var open_seats = capacity - ghosts.size()
	
	for i in range(new_ghosts.size()):
		if i < open_seats:
			var ghost:Ghost = new_ghosts.pop_back()
			ghost.boarded.connect(_on_ghost_boarded)
			boarding.append(ghost)
			awaiting_boarding.append(ghost)
	
	if not boarding.is_empty():
		ghosts.append_array(boarding)
		train_car.add_ghosts_to_seat(ghosts)
	
	return boarding


func _on_ghost_disembarked(ghost:Ghost) -> void:
	awaiting_disembark.erase(ghost)
	if awaiting_disembark.is_empty():
		disembarked.emit(disembarking)


func _on_ghost_boarded(ghost:Ghost) -> void:
	awaiting_boarding.erase(ghost)
	if awaiting_boarding.is_empty():
		boarded.emit(boarding)
