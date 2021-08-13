extends KinematicBody2D

export var fall_speed = 100
export var move_speed = 200
export var possess_offset = Vector2(10, -23)
signal map_exit

var possessed = null
var next_possession = null
var can_interact = true
var facing = 1.0
	
signal character_value_changes(new_value)
signal character_portrait_changes(new_portrait)

func _ready():
	$TravelTimer.connect("timeout", self, "enable_interact")

func enable_interact():
	can_interact = true

func teleport_character(character):
	possessed.trigger_teleport(character.position)
	character.trigger_teleport(possessed.position)
	position = possessed.position

	get_parent().play_sound("teleport")

func possess_nearby():
	for area in $PossessingArea.get_overlapping_areas():
		possess_target(area.get_parent())
		
		if possessed != null:
			break

func possess_target(target):
	if target.possess_character():
		possessed = target
		next_possession = null
		get_parent().change_active_character(possessed.get_id())
		get_parent().play_sound("warp_to_host")
		can_interact = false
		$TravelTimer.start()

func stop_possession():
	possessed = null
	get_parent().change_active_character(-1)
	if next_possession != null:
		possess_target(next_possession)
	else:
		get_parent().change_active_character(-1)
		get_parent().play_sound("game_over")
		get_parent().reset_map()

func compute_offset():
	return possessed.position + Vector2(-possessed.facing * possess_offset.x, possess_offset.y)

func set_spirit_facing():
	if facing != possessed.facing:
		facing = possessed.facing
		scale.x *= -1.0

func process_input(jump, special, horizontal_move, interact, holding_down, death):
	if get_parent().is_paused():
		return

	if possessed == null:
		if jump or holding_down or horizontal_move != 0.0 or special or interact:
			possess_nearby()
	else:
		set_spirit_facing()
		if death:
			possessed.set_dying()
		if (possessed.process_input(jump, special, horizontal_move, interact, holding_down)):
			position = lerp(position, compute_offset(), 0.15)
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
	if not can_interact:
		return

	if not area.get_parent().is_dead():
		if possessed == area.get_parent():
			return
		
		if next_possession == area.get_parent():
			return
		
		if next_possession != null:
			next_possession.remove_tag()

		next_possession = area.get_parent()
		next_possession.tag_character()
		if not get_parent().is_paused():
			get_parent().play_sound("mark_as_possessed")

func _on_EndArea_area_entered(area):
	if not can_interact:
		return
	
	emit_signal("map_exit")
