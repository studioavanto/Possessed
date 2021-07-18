extends Node

export(String, MULTILINE) var map_end_text = ""
export var map_music_id = -1
export var level_title = "default"
export(Color) var map_overlay_color

var map_paused = true

func get_player_character():
	return $PlayerCharacter

func is_paused():
	return map_paused

func set_pause(pause):
	map_paused = pause

func play_sound(sound_string):
	get_parent().play_sound(sound_string)

func teleport_character(character):
	$PlayerCharacter.teleport_character(character)

func get_possessed_character_id():
	return $PlayerCharacter.possessed.get_instance_id()

func reset_map():
	get_parent().reset_map()

func change_active_character(new_character):
	get_parent().change_active_character(new_character)
