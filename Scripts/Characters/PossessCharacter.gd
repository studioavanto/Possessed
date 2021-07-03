extends "res://Scripts/Objects/Carryable.gd"
export var lifetime = 200
export var jump_fall_reduction = 1000.0
export var jump_start_speed = 420.0
export var run_speed = 12
export var max_age = 1000
export var max_jump_time = 0.3
export var unload_time = 1.0
export var dash_time = 1.0
export var acceleration = 75.0

enum CharacterState { IDLE, RUNNING, JUMPING, DASHING, UNLOADING, SPECIAL, DEATH }
enum CharacterStage { CHILLIN, POSSESSED, DEAD }

var jump = false
var use_special = false
var use_interact = false
var jump_time = 0.0
var x_speed = 0.0
var x_input_dir = 1.0
var y_speed = 100
var current_age = 0
var unloading_timer = 0.0
var dash_timer = 0.0

var character_state = CharacterState.IDLE
var character_stage = CharacterStage.CHILLIN

func possess_character():
	if character_stage == CharacterStage.DEAD:
		return false

	character_stage = CharacterStage.POSSESSED
	return true
	
func is_dead():
	return (character_stage == CharacterStage.DEAD)

func process_input(n_jump, n_special, n_horizontal_move, n_interact):
	if character_stage == CharacterStage.DEAD:
		return false

	jump = n_jump
	use_special = n_special
	x_input_dir = n_horizontal_move
	use_interact = n_interact
	
	if x_input_dir > 0.0:
		facing = 1.0
	elif x_input_dir < 0.0:
		facing = -1.0

	return true

func get_id():
	return -1
	
func get_relative_age():
	return int(float(100 * current_age) / max_age)

func process_special():
	pass
	
func process_interact():
	for area in $InteractArea.get_overlapping_areas():
		area.get_parent().interact()
		
func kill_character():
	character_stage = CharacterStage.DEAD

func _physics_process(_delta):
	if character_stage == CharacterStage.CHILLIN :
		._physics_process(_delta)
		return

	if x_input_dir > 0.0:
		x_speed = x_speed + facing * acceleration * _delta
	elif x_input_dir < 0.0:
		x_speed = x_speed + facing * acceleration * _delta
	elif x_input_dir == 0.0 and abs(x_speed) <= 0.1*run_speed:
		x_speed = 0.0
	elif x_input_dir == 0.0 and x_speed > 0.0:
		x_speed = x_speed - acceleration * _delta
	elif x_input_dir == 0.0 and x_speed < 0.0:
		x_speed = x_speed + acceleration * _delta

	if abs(x_speed) > run_speed:
		x_speed = run_speed*facing
	
	if jump and jump_time == 0.0:
		y_speed = -jump_start_speed 
		jump_time += _delta
	elif jump and jump_time < max_jump_time:
		y_speed += - jump_fall_reduction * _delta
		jump_time += _delta
	
	if(use_special):
		process_special()
		
	if(use_interact):
		process_interact()
	
	if character_state == CharacterState.UNLOADING:
		x_speed = 0.0
		unloading_timer += _delta
	
	if unloading_timer > unload_time:
		unloading_timer = 0.0
		character_state = CharacterState.IDLE
		
	if character_state == CharacterState.DASHING:
		dash_timer += _delta
	
	if dash_timer > dash_time:
		dash_timer = 0.0
		character_state = CharacterState.IDLE
	
	move_and_slide(Vector2(run_speed * x_speed, y_speed), Vector2(0, -1))
	
	if not is_on_floor():
		y_speed += fall_speed * _delta
	else:
		y_speed = 0.0
		jump_time = 0.0

	if character_stage == CharacterStage.DEAD:
		return
	
	if character_stage != CharacterStage.CHILLIN:
		current_age += 1
	
	if current_age == max_age:
		if character_stage == CharacterStage.POSSESSED:
			kill_character()
		else:
			character_stage += 1
			current_age = 0
	
	jump = false
	use_special = false

func _on_HurtBox_area_entered(area):
	kill_character()
