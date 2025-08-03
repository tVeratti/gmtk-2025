class_name AudioUtility
extends Node


static func fade_audio(audio_player:AudioStreamPlayer, to_volume:float, duration:float) -> Tween:
	var tween: = audio_player.get_tree().create_tween()
	tween.tween_property(audio_player, "volume_db", to_volume, duration)
	return tween


static func fade_inside(root:Node, on:bool) -> void:
	var tween: = root.get_tree().create_tween()
	tween.tween_method(
		_tween_eq_bus,
		0.0 if on else 1.0,
		1.0 if on else 0.0,
		0.2)


static func _tween_eq_bus(value:float) -> void:
	var bus_index = AudioServer.get_bus_index("Inside")
	var bus_effect:AudioEffectEQ6 = AudioServer.get_bus_effect(bus_index, 0)
	
	var lerp_3 = lerp(0.0, -15.0, value)
	bus_effect.set_band_gain_db(3, lerp_3)
	
	var lerp_4 = lerp(0.0, -20.0, value)
	bus_effect.set_band_gain_db(4, lerp_4)
	
	var lerp_5 = lerp(0.0, -40.0, value)
	bus_effect.set_band_gain_db(5, lerp_5)
