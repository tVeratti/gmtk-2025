class_name Station
extends Node3D


const MIN_BOARDERS:int = 2
const MAX_BOARDERS:int = 6


@export var track_position:float = 0.0


var index:int = 0
var num_boarders:int = 0


func _ready() -> void:
	generate_boarders()
	MapManager.station_ready.emit(self)
	MapManager.station_approaching.connect(_on_station_approaching)


func generate_boarders() -> void:
	num_boarders = floor(randf_range(MIN_BOARDERS, MAX_BOARDERS))


func _on_station_approaching(station:Station) -> void:
	if station == self:
		generate_boarders()
