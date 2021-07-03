extends KinematicBody2D
export var fall_speed = 10.0
export var lifetime = 200
export var jump_fall_reduction = 5.0
export var jump_start_speed = 100.0
export var run_speed = 200
export var max_age = 1000
export var max_jump_time = 0.3

enum CharacterState { IDLE, RUNNING, JUMPING, SPECIAL, DEATH }
enum CharacterStage { CHILLIN, POSSESSED, DEAD }

var jump = false
var use_special = false
var use_interact = false
var jump_time = 0.0
var move_x = 0.0
var move_y = 100
var current_age = 0
var jump_speed = 0.0

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
	move_x = n_horizontal_move
	use_interact = n_interact

	return true

func _physics_process(_delta):
	
	if jump and jump_time == 0.0:
		jump_speed = jump_start_speed + 100
		move_y = -jump_speed 
		jump_time += _delta
	elif jump and jump_time < max_jump_time:
		jump_speed = jump_speed + jump_fall_reduction
		move_y = -jump_speed
		jump_time = jump_time + _delta
	elif not jump:
		jump_time = max_jump_time
	
	move_and_slide(Vector2(run_speed * move_x, move_y), Vector2(0, -1))
	
	if not is_on_floor():
		move_y += fall_speed
	else:
		move_y = 100
		jump_time = 0.0
		jump_speed = 0.0
	if character_stage == CharacterStage.DEAD:
		return
	
	if character_stage != CharacterStage.CHILLIN:
		current_age += 1
	
	if current_age == max_age:
		character_stage += 1
		current_age = 0
	
	jump = false
	use_special = false
	move_x = 0.0
