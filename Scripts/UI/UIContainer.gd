extends CanvasLayer

func connect_character_to_ui(character):
	character.connect("character_value_changes", $CharacterCounter, "change_value")
	character.connect("character_portrait_changes", $CharacterCounter, "change_portrait")
