extends Control


@export var map_3d:Map3D


@onready var path_2d:Path2D = %Path2D
@onready var path_follow_2d:PathFollow2D = %PathFollow2D
@onready var line_2d:Line2D = %Line2D


func _ready() -> void:
	path_2d.curve = _get_track_curve()
	line_2d.points = path_2d.curve.get_baked_points()


func _process(_delta):
	path_follow_2d.progress_ratio = MapManager.track_position


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
