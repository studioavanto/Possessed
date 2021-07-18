extends "res://Scripts/Sounds/CharacterAudio.gd"

func _ready():
	walk_sounds = [
		preload("res://Resources/Sounds/Characters/barba_walk1.ogg"),
		preload("res://Resources/Sounds/Characters/barba_walk2.ogg"),
		preload("res://Resources/Sounds/Characters/barba_walk3.ogg"),
		preload("res://Resources/Sounds/Characters/barba_walk4.ogg"),
	]
	
	audio_effects = {
		"death": [ preload("res://Resources/Sounds/Characters/barba_death.ogg"), -5.0 ],
		"jump": [ preload("res://Resources/Sounds/Characters/jump.ogg"), -5.0 ],
		"throw": [ preload("res://Resources/Sounds/Characters/barba_throw.ogg"), -5.0 ],
		"pickup": [ preload("res://Resources/Sounds/Characters/barba_pickup.ogg"), -7.0 ]
	}
