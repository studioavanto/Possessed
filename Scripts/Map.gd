extends Node

func get_player_character():
	return $PlayerCharacter

func set_pause(pause):
	return

func teleport_character(character):
	$PlayerCharacter.teleport_character(character)

func get_possessed_character_id():
	return $PlayerCharacter.possessed.get_instance_id()
