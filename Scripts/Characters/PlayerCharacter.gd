extends KinematicBody2D

export var fall_speed = 100
export var move_speed = 200

var possessed = null
var next_possession = null

func possess_nearby():
	for area in $PossessingArea.get_overlapping_areas():
		possess_target(area.get_parent())
		
		if possessed != null:
			break

func possess_target(target):
	if target.possess_character():
		possessed = target
		next_possession = null
		set_collision_mask_bit(0, false)

func stop_possession():
	set_collision_mask_bit(0, true)
	possessed = null
	
	if next_possession != null:
		possess_target(next_possession)
	else:
		# LOSE GAME IF NO POSSESS TARGET!
		pass

func process_input(jump, special, horizontal_move, interact):
	if possessed == null:
		if special:
			possess_nearby()

		move_and_slide(Vector2(move_speed * horizontal_move, fall_speed))
	else:
		if (possessed.process_input(jump, special, horizontal_move, interact)):
			position = lerp(position, possessed.position, 0.25)
		else:
			stop_possession()

func _on_PossessingArea_area_entered(area):
	if not area.get_parent().is_dead():
		next_possession = area.get_parent()
