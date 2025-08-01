# disembark.gd
extends TrainState


func enter(data := {}) -> void:
	train.info.text = "Disembarking at Station %s" % data.station_index
	train.passengers.try_disembark_passengers(data.station_index)
	
	# TODO: Connect signal to await disembark animations
	await get_tree().create_timer(1.0).timeout
	finished.emit(BOARD, data)
