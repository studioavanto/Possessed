extends CanvasLayer

func connect_character_to_ui(character):
	$CharacterCounter.connect("character_value_changes", character, "change_value")
	$CharacterCounter.connect("character_portrait_changes", character, "change_portrait")
