extends Node

export var map_music_id = -1

func get_player_character():
	return $PlayerCharacter

func set_pause(pause):
	return

func play_sound(sound_string):
	get_parent().play_sound(sound_string)

func teleport_character(character):
	$PlayerCharacter.teleport_character(character)

func get_possessed_character_id():
	return $PlayerCharacter.possessed.get_instance_id()

func reset_map():
	get_parent().reset_map()
