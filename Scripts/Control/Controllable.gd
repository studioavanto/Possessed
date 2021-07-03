extends Node

var control_id: int = -1

func get_control_id():
	return control_id

func does_have_control():
	return get_parent().get_gamestate() == control_id

func handle_inputs():
	print("Handle inputs function has not been overridden!")

func _physics_process(_delta):
	if does_have_control():
		handle_inputs()
