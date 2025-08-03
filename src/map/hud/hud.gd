extends Control


@export var map_3d:Map3D
@export var train:Train


var station_label_scene = load("uid://df0ehva33767t")


@onready var path_2d:Path2D = %Path2D
@onready var path_follow_2d:PathFollow2D = %PathFollow2D
@onready var line_2d:Line2D = %Line2D

@onready var info:Label = %Info
@onready var karma:Label = %Karma
@onready var karma_progress_bar:ProgressBar = %KarmaProgressBar
@onready var volume_slider:HSlider = %Volume


func _ready() -> void:
	path_2d.curve = _get_track_curve()
	line_2d.points = path_2d.curve.get_baked_points()
	
	for station in MapManager.stations:
		var station_label:PathFollow2D = station_label_scene.instantiate()
		var label = station_label.get_node("Label")
		label.text = station.station_name
		path_2d.add_child(station_label)
		path_2d.move_child(station_label, 0)
		station_label.progress_ratio = station.track_position
	
	train.status_changed.connect(_on_train_status_changed)
	
	_on_karma_changed(0)
	KarmaManager.karma_gained.connect(_on_karma_changed)
	KarmaManager.karma_target_changed.connect(_on_karma_changed)
	
	_set_volume(0.9)


func _process(_delta):
	path_follow_2d.progress_ratio = MapManager.track_position
	
	karma_progress_bar.value = float(KarmaManager.karma) / float(KarmaManager.karma_target)


func _get_track_curve() -> Curve2D:
	var curve_3d:Curve3D = map_3d.track.path_3d.curve
	var curve_2d:Curve2D = Curve2D.new()
	
	for i in range(curve_3d.point_count):
		var point_3d: = curve_3d.get_point_position(i)
		var point_2d: = _to_2d(point_3d)
		
		var in_3d: = curve_3d.get_point_in(i)
		var in_2d: = _to_2d(in_3d)
		
		var out_3d: = curve_3d.get_point_out(i)
		var out_2d: = _to_2d(out_3d)
		
		curve_2d.add_point(point_2d, in_2d, out_2d)
	
	# Close the curve
	curve_2d.add_point(
		curve_2d.get_point_position(0),
		curve_2d.get_point_in(0),
		curve_2d.get_point_out(0))
	
	return curve_2d


func _to_2d(v:Vector3) -> Vector2:
	return Vector2(v.x, v.z)


func _on_train_status_changed(status:String) -> void:
	info.text = status


func _on_karma_changed(_v) -> void:
	karma.text = "Karma: %s / %s" % [KarmaManager.karma, KarmaManager.karma_target]


func _on_volume_value_changed(value):
	_set_volume(value)


func _set_volume(volume:float) -> void:
	var volume_db:float = lerp(-50.0, 5.0, clamp(volume, 0.0, 1.0))
	AudioServer.set_bus_mute(0, volume < 0.1)
	AudioServer.set_bus_volume_db(0, volume_db)
	volume_slider.release_focus()
