extends "res://Scripts/Sounds/CharacterAudio.gd"

func _ready():
	walk_sounds = [
		preload("res://Resources/Sounds/Characters/thief_walk1.ogg"),
		preload("res://Resources/Sounds/Characters/thief_walk2.ogg"),
		preload("res://Resources/Sounds/Characters/thief_walk3.ogg"),
		preload("res://Resources/Sounds/Characters/thief_walk4.ogg"),
	]
	
	audio_effects = {
		"death": [ preload("res://Resources/Sounds/Characters/thief_death.ogg"), -5.0 ],
		"jump": [ preload("res://Resources/Sounds/Characters/jump.ogg"), -5.0 ],
		"dash": [ preload("res://Resources/Sounds/Characters/thief_dash.ogg"), -8.0 ]
	}
