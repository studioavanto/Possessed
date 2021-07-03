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
			carry_item.is_being_carried = false
			break

func start_carrying_target(target):
	if target.carry_target():
		carry_item = target
		$CarryHitBox.disabled = false
		set_collision_mask_bit(3, false)

func stop_carrying():
	set_collision_mask_bit(3, true)
	$CarryHitBox.disabled = true
	carry_item.is_being_carried = true
	carry_item = null

func process_special():
	carry_nearby()

func _physics_process(delta):
	._physics_process(delta)
	
	if carry_item != null:
		carry_item.position = position + carry_point_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
