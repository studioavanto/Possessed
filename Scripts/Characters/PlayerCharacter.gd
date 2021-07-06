extends KinematicBody2D

export var fall_speed = 100
export var move_speed = 200

signal map_exit

var possessed = null
var next_possession = null
	
signal character_value_changes(new_value)
signal character_portrait_changes(new_portrait)

func teleport_character(character):
	var tmp_position = character.position
	character.position = possessed.position
	possessed.position = tmp_position

func possess_nearby():
	for area in $PossessingArea.get_overlapping_areas():
		possess_target(area.get_parent())
		
		if possessed != null:
			break

func possess_target(target):
	if target.possess_character():
		possessed = target
		next_possession = null

func stop_possession():
	possessed = null
	
	if next_possession != null:
		possess_target(next_possession)
	else:
		# LOSE GAME IF NO POSSESS TARGET!
		pass
		
func process_input(jump, special, horizontal_move, interact, holding_down):
	if possessed == null:
		if special:
			possess_nearby()
	else:
		if (possessed.process_input(jump, special, horizontal_move, interact, holding_down)):
			position = lerp(position, possessed.position, 0.25)
		else:
			stop_possession()

func _process(_delta):
	if possessed != null:
		emit_signal("character_portrait_changes", possessed.get_id())
		emit_signal("character_value_changes", possessed.get_relative_age())
	else:
		emit_signal("character_portrait_changes", 0)
		emit_signal("character_value_changes", 0)

func _on_PossessingArea_area_entered(area):
	if not area.get_parent().is_dead():
		if possessed == area.get_parent():
			return
		
		if next_possession != null:
			next_possession.remove_tag()

		next_possession = area.get_parent()
		next_possession.tag_character()

func _on_EndArea_area_entered(area):
	emit_signal("map_exit")
