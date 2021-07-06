extends "res://Scripts/Characters/PossessCharacter.gd"

export var carry_point_offset = Vector2(0,-64.0)

var carry_item = null

func _ready():
	$CarryHitBox.disabled = true

func carry_nearby():
	for area in $CarryingArea.get_overlapping_areas():
		start_carrying_target(area.get_parent())
		if carry_item != null:
			break

func start_carrying_target(target):
	if target.carry_target():
		carry_item = target
		character_state = CharacterState.CARRYING
		$CarryHitBox.disabled = false
		$CarryingArea.set_collision_mask_bit(3, false)

func throw_object():
	$CarryingArea.set_collision_mask_bit(3, true)
	$CarryHitBox.disabled = true
	carry_item.throw(Vector2(x_speed, y_speed), facing)
	carry_item.stop_being_carried()
	carry_item = null

func stop_carrying():
	$CarryingArea.set_collision_mask_bit(3, true)
	$CarryHitBox.disabled = true
	carry_item.stop_being_carried()
	carry_item.position = position + Vector2(66,0.0) * facing
	carry_item = null

func drop_box_on_top():
	$CarryingArea.set_collision_mask_bit(3, true)
	$CarryHitBox.disabled = true
	carry_item.stop_being_carried(true)
	carry_item = null
	
func process_special():
	if carry_item == null and has_space_above:
		carry_nearby()
	elif carry_item != null:
		if holding_down:
			stop_carrying()
		else:
			throw_object()

func get_id():
	return 1

func kill_character():
	if carry_item != null:
		drop_box_on_top()

	.kill_character()

func process_physics(delta):
	.process_physics(delta)

	if carry_item != null:
		carry_item.position = position + carry_point_offset
