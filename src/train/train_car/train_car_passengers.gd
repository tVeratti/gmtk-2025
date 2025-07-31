class_name TrainCarPassengers
extends Node


signal disembarked(g:Array)
signal boarded(g:Array)


var ghosts:Array = []


@onready var capacity:int = owner.capacity


## Check all passengers for valid disembarking status and remove them.
func check_passengers_disembarking(station_index:int) -> void:
	var disembarking:Array = []
	
	for ghost in ghosts:
		if ghost is Ghost:
			if ghost.can_disembark(station_index):
				disembarking.append(ghost)
	
	if not disembarking.is_empty():
		# Remove disembarking passengers from the array
		ghosts = ghosts.filter(func(g): return not disembarking.has(g))
		
		disembarked.emit(disembarking)


## Determine if there is any capacity for new passengers.
func has_capacity() -> bool:
	return ghosts.size() < capacity


## Board as many passengers as possible into this car, return overflow passengers.
func try_board_passengers(new_ghosts:Array) -> Array:
	var open_seats = capacity - ghosts.size()
	var boarding:Array = []
	for i in range(new_ghosts.size()):
		if i < open_seats:
			boarding.append(new_ghosts.pop_back())
	
	if not boarding.is_empty():
		ghosts.append_array(boarding)
		boarded.emit(boarding)
	
	return new_ghosts
