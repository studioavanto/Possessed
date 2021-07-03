extends TextureRect

var portraits = [
	preload("res://Resources/UI/life_thief.png"),
	preload("res://Resources/UI/life_barbarian.png"),
	preload("res://Resources/UI/life_thief.png"),
	preload("res://Resources/UI/life_wizard.png"),
]

var current_portrait = 0

func change_value(value):
	$TextureProgress.value = value

func change_portrait(new_portrait):
	if new_portrait != current_portrait:
		$CharacterPortrait.texture = portraits[new_portrait]
