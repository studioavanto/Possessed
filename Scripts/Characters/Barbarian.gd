extends "res://Scripts/Characters/PossessCharacter.gd"

export var carry_point_offset = Vector2(0,5.0)

var carry_item = null
var carry_point = self.position + carry_point_offset

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func carry_nearby():
	for area in $CarryingArea.get_overlapping_areas():
		start_carrying_target(area.get_parent())
		if carry_item != null:
			break

func start_carrying_target(target):
	if target.carry_target():
		carry_item = target
		set_collision_mask_bit(0, false)

func stop_carrying():
	set_collision_mask_bit(0, true)
	carry_item = null

func process_special():
	carry_nearby()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
