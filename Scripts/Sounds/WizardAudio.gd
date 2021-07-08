extends "res://Scripts/Sounds/CharacterAudio.gd"

func _ready():
	walk_sounds = [
		preload("res://Resources/Sounds/Characters/wizard_walk1.ogg"),
		preload("res://Resources/Sounds/Characters/wizard_walk2.ogg"),
		preload("res://Resources/Sounds/Characters/wizard_walk3.ogg"),
		preload("res://Resources/Sounds/Characters/wizard_walk4.ogg"),
	]
	
	audio_effects = {
		"death": [ preload("res://Resources/Sounds/Characters/wizard_death.ogg"), 0.0 ],
		"jump": [ preload("res://Resources/Sounds/Characters/jump.ogg"), 0.0 ],
		"cast": [ preload("res://Resources/Sounds/Characters/wizard_cast.ogg"), 0.0 ]
	}
