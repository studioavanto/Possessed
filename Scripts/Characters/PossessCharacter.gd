extends "res://Scripts/Objects/Carryable.gd"
export var fall_speed = 1000.0
export var lifetime = 200
export var jump_fall_reduction = 1000.0
export var jump_start_speed = 500.0
export var run_speed = 200
export var max_age = 1000
export var max_jump_time = 0.3

enum CharacterState { IDLE, RUNNING, JUMPING, SPECIAL, DEATH }
enum CharacterStage { CHILLIN, POSSESSED, DEAD }

var jump = false
var use_special = false
var use_interact = false
var jump_time = 0.0
var x_speed = 0.0
var y_speed = 100
var current_age = 0

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
	x_speed = n_horizontal_move
	use_interact = n_interact

	return true

func process_special():
	pass

func kill_character():
	character_stage = CharacterStage.DEAD

func _physics_process(_delta):
	if character_stage == CharacterStage.CHILLIN :
		._physics_process(_delta)
		return

	if jump and jump_time == 0.0:
		y_speed = -jump_start_speed 
		jump_time += _delta
	elif jump and jump_time < max_jump_time:
		y_speed += - jump_fall_reduction * _delta
		jump_time += _delta
	
	if(use_special):
		process_special()
	
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
	x_speed = 0.0

func _on_HurtBox_area_entered(area):
	kill_character()
