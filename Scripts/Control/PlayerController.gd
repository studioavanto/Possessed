extends "res://Scripts/Control/Controllable.gd"

var player_character = null

func set_player_character(new_character):
	player_character = new_character

func remove_character_body():
	player_character = null

func handle_inputs():
	if player_character == null:
		return
	
	var jump = false
	var special = false
	var interact = false
	var death = false
	var holding_down = false
	var horizontal_move = 0.0
	
	if Input.is_action_pressed("press_down"):
		holding_down = true
	
	if Input.is_action_pressed("press_up"):
		jump = true
		
	if Input.is_action_just_pressed("special"):
		special = true
		
	if Input.is_action_just_pressed("interact"):
		interact = true
		
	if Input.is_action_just_pressed("get_older"):
		death = true

	if Input.is_action_just_pressed("reset"):
		get_parent().reset_map()

	horizontal_move = Input.get_action_strength("press_right") - Input.get_action_strength("press_left")
	
	player_character.process_input(jump, special, horizontal_move, interact, holding_down, death)
	
