extends Node2D


const BUMP_MIN_TIMER:float = 0.3
const BUMP_MAX_TIMER:float = 1.3
const BUMP_DELAY:float = 0.3

const BUMP_AMOUNT_MIN:float = 1.0
const BUMP_AMOUNT_MAX:float = 2.0
const BUMP_LARGE_THRESHOLD:float = 0.8


@onready var train_cars:Array = get_children()


func _ready() -> void:
	train_cars.reverse()
	_start_bump_timer()


func add_bump() -> void:
	var amount = -randf_range(BUMP_AMOUNT_MIN, BUMP_AMOUNT_MAX)
	if randf() > BUMP_LARGE_THRESHOLD:
		amount *= 2.0
	
	var index:int = 0
	for train_car in train_cars:
		var tween: = get_tree().create_tween()
		tween.tween_property(train_car, "position:y", amount, 0.3).set_delay(index * BUMP_DELAY)
		tween.tween_property(train_car, "position:y", 0.0, 0.3)
		index += 1
	
	_start_bump_timer()


func _start_bump_timer(_x = null) -> void:
	var random_time = randf_range(BUMP_MIN_TIMER, BUMP_MAX_TIMER)
	var bump_timer = get_tree().create_timer(random_time)
	bump_timer.timeout.connect(add_bump)
