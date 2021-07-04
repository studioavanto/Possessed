extends "res://Scripts/Characters/PossessCharacter.gd"

export var carry_point_offset = Vector2(0,-64.0)

var carry_item = null

# Called when the node enters the scene tree for the first time.
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
		set_collision_mask_bit(3, false)

func throw_object():
	set_collision_mask_bit(3, true)
	$CarryHitBox.disabled = true
	character_state = CharacterState.UNLOADING
	carry_item.throw(Vector2(x_speed, y_speed), facing)
	carry_item.stop_being_carried()
	
func stop_carrying():
	set_collision_mask_bit(3, true)
	$CarryHitBox.disabled = true
	character_state = CharacterState.UNLOADING
	carry_item.stop_being_carried()

func process_special():
	if carry_item == null:
		carry_nearby()
	else:
		if holding_down:
			stop_carrying()
		else:
			throw_object()

func get_id():
	return 1

func kill_character():
	if carry_item != null:
		stop_carrying()

	.kill_character()

func _physics_process(_delta):
	._physics_process(_delta)
	
	if carry_item != null:
		if(character_state == CharacterState.UNLOADING and holding_down == false):
			carry_item = null
		elif character_state == CharacterState.UNLOADING:
			carry_item.position = position + Vector2(66,0.0) * facing
		else:
			carry_item.position = position + carry_point_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
