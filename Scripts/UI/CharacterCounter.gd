extends TextureRect

var portraits = [
	preload("res://Resources/UI/UI_portrait_ghost.png"),
	preload("res://Resources/UI/UI_portrait_barba.png"),
	preload("res://Resources/UI/UI_portrait_thief.png"),
	preload("res://Resources/UI/UI_portrait_wizard.png"),
]

var current_portrait = -1

func _ready():
	change_portrait(0)

func change_value(value):
	$TextureProgress.value = value

func change_portrait(new_portrait):
	if new_portrait != current_portrait:
		$CharacterPortrait.texture = portraits[new_portrait]
		current_portrait = new_portrait
