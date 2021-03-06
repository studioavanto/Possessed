extends "res://Scripts/Objects/Carryable.gd"

export var lifetime = 200
export var jump_fall_reduction = 710.0
export var jump_start_speed = 755.0
export var run_speed = 290
export var max_age = 633
export var max_jump_time = 0.25
export var unload_time = 1.0
export var acceleration = 2000.0
export var drag = 2500.0
export var push_constant = 0.5
export var dash_cooldown_time = 0.05
export var ledge_jump_timer = 0.1

enum CharacterState { IDLE, RUNNING, JUMPING, SPECIAL, DEATH }
enum CharacterStage { CHILLIN, POSSESSED, DEAD }

var tagged = false
var jump = false
var use_special = false
var use_interact = false
var holding_down = false
var jump_time = 0.0
var x_input_dir = 0.0
var current_age = 0
var unloading_timer = 0.0
var facing = 1.0
var air_jump = false
var has_acted = false

var blood_splatter_particles = null

var character_state = CharacterState.IDLE
var character_stage = CharacterStage.CHILLIN

func _ready():
	$JumpTimer.connect("timeout", self, "end_ledge_jump")
	blood_splatter_particles = preload("res://Scenes/GameObjects/ParticleEffects/BloodSplatter.tscn").instance()
	add_child(blood_splatter_particles)
	$Light2D.max_alpha = 0.0
	has_acted = get_parent().get_has_act_toggle()

func end_ledge_jump():
	air_jump = false

func start_air_timer():
	air_jump = true
	$JumpTimer.start(ledge_jump_timer)

func set_possess_light(value):
	if value:
		$Light2D.fade_light_in()
	else:
		$Light2D.fade_light_out()

func get_air_drag():
	if character_stage == CharacterStage.CHILLIN:
		return 0.0
	else:
		return drag

func get_max_speed():
	if character_stage == CharacterStage.CHILLIN:
		return run_speed * 10
	else:
		return run_speed

func get_character_sprite():
	return $AnimatedSprite

func possess_character():
	if character_stage == CharacterStage.DEAD:
		return false

	character_stage = CharacterStage.POSSESSED
	$EvilHalo.emitting = true
	$PickingArea.set_collision_layer_bit(3, false)
	remove_tag()
	set_possess_light(true)
	return true
	
func tag_character():
	tagged = true
	$TaggedSprite.animation = "tagged"
	set_possess_light(true)

func remove_tag():
	tagged = false
	$TaggedSprite.animation = "default"
	set_possess_light(false)

func is_dead():
	return (character_stage == CharacterStage.DEAD)

func carry_target():
	if is_dead():
		return false
	
	return .carry_target()

func process_input(n_jump, n_special, n_horizontal_move, n_interact, n_holding_down):
	if character_stage == CharacterStage.DEAD:
		return false

	jump = n_jump
	use_special = n_special
	x_input_dir = n_horizontal_move
	use_interact = n_interact
	holding_down = n_holding_down
	
	if not has_acted and (jump or use_interact or use_special or x_input_dir != 0.0):
		has_acted = true
		
	return true

func get_id():
	return -1
	
func get_relative_age():
	return int(float(100 * current_age) / max_age)

func process_special():
	pass

func special_physics_process():
	pass

func unique_physics_modifiers():
	pass

func set_character_animations():
	if CharacterStage.DEAD != character_stage:
		match character_state:
			CharacterState.IDLE:
				play_animation("default")
			CharacterState.RUNNING:
				play_animation("run")
			CharacterState.JUMPING:
				if y_speed > 0.0:
					play_animation("jump_down")
				else:
					play_animation("jump_up")
			CharacterState.SPECIAL:
				play_animation("special")

func play_animation(new_animation):
	if $AnimatedSprite.animation != new_animation:
		$AnimatedSprite.animation = new_animation

func character_is_on_floor_after_move():
	pass

func process_interact():
	for area in $InteractArea.get_overlapping_areas():
		area.get_parent().interact()
	
func set_dying():
	character_state = CharacterState.DEATH

func kill_character():
	character_stage = CharacterStage.DEAD
	$AnimatedSprite.animation = "death"
	$EvilHalo.emitting = false
	$HitBox.disabled = true
	$GraveHitBox.disabled = false
	set_collision_layer_bit(0, true)
	$HurtBox.set_collision_layer_bit(8, false)
	$CharacterAudio.play_sound("death")
	set_possess_light(false)
	remove_tag()

	if facing == -1.0:
		facing = 1.0
		scale.x = -1.0

func push_on_front():
	var speed_mod = 1.0
	
	for area in $PushArea.get_overlapping_areas(): 
		if (position - area.get_parent().position).x * facing < 0:
			if area.get_parent().get_total_weight() > 1:
				speed_mod = 0.0
			else:
				speed_mod = push_constant
				area.get_parent().move_and_slide(Vector2(speed_mod * x_speed * 1.1, 0.0), Vector2(0, -1))

	return speed_mod

func get_jump_start_speed():
	if character_stage == CharacterStage.CHILLIN:
		return y_speed
	else:
		return -jump_start_speed

func swap_facing():
	if x_input_dir > 0.0 and facing == -1:
		scale.x = -1.0
		facing = 1
	elif x_input_dir < 0.0 and facing == 1:
		scale.x = -1.0
		facing = -1

func process_physics(delta):
	# The purpose to process physics is to 
	# 1. Set character state properly
	# 2. Use character state to infer character dynamics
	# 3. Set character animation state

	if character_stage == CharacterStage.DEAD:
		return

	match character_state:
		CharacterState.IDLE:
			if jump:
				$CharacterAudio.play_sound("jump")
				character_state = CharacterState.JUMPING
			elif abs(x_input_dir) > 0.5:
				character_state = CharacterState.RUNNING
			
			if use_special:
				process_special()
			elif use_interact:
				process_interact()

		CharacterState.RUNNING:
			if jump:
				$CharacterAudio.play_sound("jump")
				character_state = CharacterState.JUMPING
			elif abs(x_input_dir) < 0.05:
				character_state = CharacterState.IDLE
			
			if use_special:
				process_special()
			elif use_interact:
				process_interact()

		CharacterState.JUMPING:
			if use_special:
				process_special()
			elif use_interact:
				process_interact()
		CharacterState.SPECIAL:
			if use_special:
				process_special()

	swap_facing()
	
	# Update Character dynamics
	match character_state:
		CharacterState.IDLE:
			if abs(x_speed) <= 0.1 * run_speed:
				x_speed = 0.0
			else:
				x_speed -= sign(x_speed) * drag * delta
				
			y_speed = 100.0

		CharacterState.RUNNING:
			x_speed += facing * acceleration * delta
			
			if abs(x_speed) > get_max_speed() and 0 < facing * x_speed:
				x_speed = run_speed * facing
			
			y_speed = 100.0

		CharacterState.JUMPING:
			if abs(x_input_dir) > 0.05:
				x_speed += facing * acceleration * delta
			
				if abs(x_speed) > get_max_speed() and 0 < facing * x_speed:
					x_speed = run_speed * facing
			else:
				if abs(x_speed) <= 0.1 * run_speed:
					x_speed = 0.0
				else:
					x_speed -= sign(x_speed) * get_air_drag() * delta

			if jump_time == 0.0 or (air_jump and jump):
				y_speed = get_jump_start_speed()
				 
				jump_time = delta
				end_ledge_jump()

			elif jump and jump_time < max_jump_time:
				y_speed += fall_speed * delta - jump_fall_reduction * delta
				jump_time += delta
			else:
				y_speed += fall_speed * delta

		CharacterState.DEATH:
			y_speed += fall_speed * delta

		CharacterState.SPECIAL:
			special_physics_process()
	
	set_terminal_velocity()
	
	unique_physics_modifiers()
	var speed_mod = push_on_front()
	
	var vec = move_and_slide(Vector2(speed_mod * x_speed, 0.0))

	if vec.x == 0.0:
		x_speed = 0.0
	
	if not is_being_carried:
		vec = move_and_slide(Vector2(0.0, y_speed), Vector2(0, -1), true)	
	
		if vec.y == 0.0:
			y_speed = 10.0
	
	if is_on_floor():
		character_is_on_floor_after_move()
		if character_state == CharacterState.JUMPING:
			character_state = CharacterState.IDLE
			jump_time = 0.0

			if character_stage == CharacterStage.CHILLIN:
				x_speed = 200 * facing

		elif character_state == CharacterState.DEATH:
			x_speed = 0.0
			kill_character()

	elif not is_on_floor() and [CharacterState.IDLE, CharacterState.RUNNING].has(character_state):
		character_state = CharacterState.JUMPING
		jump_time = max_jump_time
		start_air_timer()
	
	set_character_animations()

	if is_on_floor() and abs(x_input_dir) > 0:
		$CharacterAudio.play_footstep()

	if character_stage == CharacterStage.POSSESSED and has_acted:
		current_age += 1
		if current_age >= max_age:
			character_state = CharacterState.DEATH

	jump = false
	use_special = false
	x_input_dir = 0.0
	use_interact = false
	holding_down = false

func _on_HurtBox_area_entered(area):	
	if character_state == CharacterState.DEATH:
		return

	if area.get_collision_layer_bit(2):
		blood_splatter_particles.emitting = true
		character_state = CharacterState.DEATH
		x_speed = 0
		y_speed = -500
	elif area.get_collision_mask_bit(8):
		if not area.get_parent().has_been_used:
			area.get_parent().start_destroy_projectile()
			get_parent().teleport_character(self)
