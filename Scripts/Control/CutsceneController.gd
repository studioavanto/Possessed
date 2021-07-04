extends "res://Scripts/Control/Controllable.gd"

signal proceed

func handle_inputs():
	if Input.is_action_just_pressed("special"):
		emit_signal("proceed")
