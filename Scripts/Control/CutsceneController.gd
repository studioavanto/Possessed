extends "res://Scripts/Control/Controllable.gd"

signal proceed
signal start_new_game

func handle_inputs():
	if Input.is_action_just_pressed("special"):
		emit_signal("start_new_game")
		
	if Input.is_action_just_pressed("press_up") or Input.is_action_just_pressed("get_older"):
		emit_signal("proceed")
