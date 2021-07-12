extends "res://Scripts/Objects/Carryable.gd"

export var lifetime = 200
export var jump_fall_reduction = 2550.0
export var jump_start_speed = 380.0
export var run_speed = 17
export var max_age = 600
export var max_jump_time = 0.35
export var unload_time = 1.0
export var dash_time = 0.25
export var dash_speed = 700
export var acceleration = 150.0
export var push_constant = 0.5
export var dash_cooldown_time = 0.05

enum CharacterState { IDLE, RUNNING, JUMPING, DASHING, UNLOADING, SPECIAL, DEATH, CARRYING }
enum CharacterStage { CHILLIN, POSSESSED, DEAD }

var tagged = false
var jump = false
var use_special = false
var use_interact = false
var holding_down = false
var jump_time = 0.0
var x_input_dir = 1.0
var current_age = 0
var unloading_timer = 0.0
var dash_timer = 0.0
var can_dash = true
var dash_cooldown = 0.0

var character_state = CharacterState.IDLE
var character_stage = CharacterStage.CHILLIN

func get_character_sprite():
	return $AnimatedSprite

func possess_character():
	if character_stage == CharacterStage.DEAD:
		return false

	character_stage = CharacterStage.POSSESSED
	$PickingArea.set_collision_layer_bit(3, false)
	remove_tag()
	return true
	
func tag_character():
	tagged = true
	$TaggedSprite.animation = "tagged"

func remove_tag():
	tagged = false
	$TaggedSprite.animation = "default"

func is_dead():
	return (character_stage == CharacterStage.DEAD)

func process_input(n_jump, n_special, n_horizontal_move, n_interact, n_holding_down):
	if character_stage == CharacterStage.DEAD:
		return false

	jump = n_jump
	use_special = n_special
	x_input_dir = n_horizontal_move
	use_interact = n_interact
	holding_down = n_holding_down
	
	if x_input_dir > 0.0 and facing == -1.0:
		facing = 1.0
		scale.x = -1.0
	elif x_input_dir < 0.0 and facing == 1.0:
		facing = -1.0
		scale.x = -1.0

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
	$AnimatedSprite.animation = "death"
	$HitBox.disabled = true
	$GraveHitBox.disabled = false
	set_collision_layer_bit(0, true)
	$HurtBox.set_collision_layer_bit(8, false)
	$CharacterAudio.play_sound("death")
	
	if facing == -1.0:
		facing = 1.0
		scale.x = -1.0

func process_physics(delta):
	if character_stage != CharacterStage.POSSESSED:
		.process_physics(delta)
		return
	
	if character_state == CharacterState.DEATH:
		y_speed += fall_speed * delta
		move_and_slide(Vector2(x_speed * run_speed, y_speed), Vector2(0, -1))
		if is_on_floor():
			kill_character()
		return
	
	current_age += 1
	
	if character_state == CharacterState.DASHING:
		dash_timer += delta
	
		if dash_timer > dash_time:
			dash_timer = 0.0
			y_speed = 0.0
			character_state = CharacterState.IDLE
			dash_cooldown = dash_cooldown_time
			can_dash = false
			
		move_and_slide(Vector2(dash_speed * facing, 0), Vector2(0, -1))
		return

	if x_input_dir > 0.0:
		x_speed += facing * acceleration * delta
	elif x_input_dir < 0.0:
		x_speed += facing * acceleration * delta
	elif x_input_dir == 0.0 and abs(x_speed) <= 0.1 * run_speed:
		x_speed = 0.0
	elif x_input_dir == 0.0 and x_speed > 0.0:
		x_speed -= acceleration * delta
	elif x_input_dir == 0.0 and x_speed < 0.0:
		x_speed += acceleration * delta

	if abs(x_speed) > run_speed and 0 < facing * x_speed:
		x_speed = run_speed * facing

	if character_state == CharacterState.CARRYING:
		if abs(x_speed) > 0.4 * run_speed:
			$AnimatedSprite.animation = "carry_run"
		else:
			$AnimatedSprite.animation = "carry_default"
	else:
		if abs(x_speed) > 0.4 * run_speed:
			$AnimatedSprite.animation = "run"
		else:
			$AnimatedSprite.animation = "default"

	if jump and jump_time == 0.0:
		$CharacterAudio.play_sound("jump")
		y_speed = - jump_start_speed 
		jump_time += delta
		
	elif jump and jump_time < max_jump_time:
		y_speed += - jump_fall_reduction * delta
		jump_time += delta
	
	if(use_special):
		process_special()

	if(use_interact):
		process_interact()
	
	if unloading_timer > unload_time:
		unloading_timer = 0.0
		character_state = CharacterState.IDLE
	
	var speed_mod = 1.0
	
	for area in $PushArea.get_overlapping_areas(): 
		if (position - area.get_parent().position).x * facing < 0:
			if area.get_parent().get_total_weight() > 1:
				speed_mod = 0.0
			else:
				speed_mod = push_constant
				area.get_parent().move_and_slide(Vector2(speed_mod * run_speed * x_speed, 0.0), Vector2(0, -1))
	
	var vec = move_and_slide(Vector2(speed_mod * run_speed * x_speed, y_speed), Vector2(0, -1))

	if is_on_floor() and abs(x_input_dir) > 0:
		$CharacterAudio.play_footstep()

	if vec.y == 0.0:
		y_speed = 0.0

	if dash_cooldown > 0.0:
		dash_cooldown -= delta

	if not is_on_floor():
		y_speed += fall_speed * delta
	else:
		y_speed = 1.0
		jump_time = 0.0
		if dash_cooldown <= 0.0:
			can_dash = true
	
	
	if current_age >= max_age:
		if character_stage == CharacterStage.POSSESSED:
			character_state = CharacterState.DEATH
		else:
			character_stage += 1
			current_age = 0
	
	jump = false
	use_special = false

func _on_HurtBox_area_entered(area):	
	if area.get_collision_layer_bit(2):
		character_state = CharacterState.DEATH
	elif area.get_collision_mask_bit(8):
		area.get_parent().start_destroy_projectile()
		get_parent().teleport_character(self)
