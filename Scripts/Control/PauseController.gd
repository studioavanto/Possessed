extends "res://Scripts/Control/Controllable.gd"

func handle_inputs():
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

	if Input.is_action_just_pressed("pause"):
		get_parent().from_pause_to_player()
