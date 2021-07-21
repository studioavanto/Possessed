extends "res://Scripts/Control/Controllable.gd"

func handle_inputs():
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()

	if Input.is_action_just_pressed("press_up"):	
		get_parent().from_pause_to_player()
