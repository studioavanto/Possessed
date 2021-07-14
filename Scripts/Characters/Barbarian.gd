extends "res://Scripts/Characters/PossessCharacter.gd"

export var carry_point_offset = Vector2(0,-64.0)
export var yeet_and_jump = false
export var throw_speed_x = 750
export var throw_speed_y = -350
export var carry_jump_start_speed = 100

var carry_item = null

func _ready():
	$CarryHitBox.disabled = true

func has_space_in_front():
	return $IsSpaceInFront.get_overlapping_bodies().empty()

func can_character_jump():
	if yeet_and_jump or get_total_weight() == 1:
		return true
	
	return false
	
func carry_nearby():
	for area in $CarryingArea.get_overlapping_areas():
		start_carrying_target(area.get_parent())
		if carry_item != null:
			break

func start_carrying_target(target):
	if target.carry_target():
		carry_item = target
		$CarryHitBox.disabled = false
		$CarryingArea.set_collision_mask_bit(3, false)
		$CharacterAudio.play_sound("pickup")

func throw_object():
	$AnimatedSprite.animation = "default"
	$CarryingArea.set_collision_mask_bit(3, true)
	$CarryHitBox.disabled = true
	carry_item.throw(Vector2(x_speed + throw_speed_x * facing, y_speed + throw_speed_y), facing)
	carry_item.stop_being_carried()
	carry_item = null
	$CharacterAudio.play_sound("throw")

func stop_carrying():
	$AnimatedSprite.animation = "default"
	$CarryingArea.set_collision_mask_bit(3, true)
	$CarryHitBox.disabled = true
	carry_item.stop_being_carried()
	carry_item.position = position + Vector2(66,0.0) * facing
	carry_item = null

func drop_box_on_top():
	$CarryingArea.set_collision_mask_bit(3, true)
	$CarryHitBox.disabled = true
	carry_item.stop_being_carried()
	carry_item = null
	
func process_special():
	if carry_item == null and has_space_above():
		carry_nearby()
	elif carry_item != null:
		if holding_down and has_space_in_front():
			stop_carrying()
		else:
			throw_object()

func play_animation(new_animation):
	if carry_item != null:
		if character_state == CharacterState.IDLE:
			.play_animation("carry_default")
		elif character_state == CharacterState.RUNNING:
			.play_animation("carry_run")
	else:
		.play_animation(new_animation)

func get_id():
	return 1

func kill_character():
	if carry_item != null:
		drop_box_on_top()

	.kill_character()

func get_jump_start_speed():
	if carry_item == null:
		return -jump_start_speed
	else:
		return -carry_jump_start_speed

func process_physics(delta):
	.process_physics(delta)

	if carry_item != null:
		carry_item.position = position + carry_point_offset
