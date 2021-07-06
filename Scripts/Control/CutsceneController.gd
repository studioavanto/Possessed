extends "res://Scripts/Control/Controllable.gd"

signal proceed

func handle_inputs():
	if Input.is_action_just_pressed("special") \
	or Input.is_action_just_pressed("press_up") \
	or Input.is_action_just_pressed("get_older"):
		emit_signal("proceed")
