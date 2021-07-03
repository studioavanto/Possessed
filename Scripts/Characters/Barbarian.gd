extends "res://Scripts/Characters/PossessCharacter.gd"

export var carry_point_offset = Vector2(0,-64.0)

var carry_item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$CarryHitBox.disabled = true

func carry_nearby():
	for area in $CarryingArea.get_overlapping_areas():
		print("hello from carry_nearby loop")
		start_carrying_target(area.get_parent())
		if carry_item != null:
			carry_item.is_being_carried = true
			break

func start_carrying_target(target):
	print("start_carrying_target attempted")
	if target.carry_target():
		carry_item = target
		$CarryHitBox.disabled = false
		set_collision_mask_bit(3, false)

func stop_carrying():
	set_collision_mask_bit(3, true)
	$CarryHitBox.disabled = true
	character_state = CharacterState.UNLOADING
	carry_item.is_being_carried = false

func process_special():
	if carry_item == null:
		print("carry item = null, attempting carry nearby")
		carry_nearby()
	else:
		stop_carrying()
func get_id():
	return 1

func _physics_process(_delta):
	
	._physics_process(_delta)
	
	if carry_item != null:
		if(character_state == CharacterState.UNLOADING):
			carry_item.position = position + Vector2(64,0.0) * facing
			carry_item = null
		else:	
			carry_item.position = position + carry_point_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
