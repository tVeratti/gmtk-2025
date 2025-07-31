extends Node


signal station_ready
signal station_approaching(station:Station)


var track_position:float = 0.0
var train_speed:float = 0.0

var stations:Array[Station] = []


func _ready() -> void:
	station_ready.connect(_on_station_ready)


func _on_station_ready(station:Station) -> void:
	station.index = stations.size()
	stations.append(station)
