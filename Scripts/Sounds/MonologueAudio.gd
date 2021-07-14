extends AudioStreamPlayer

onready var audio_effects = {
	"a": preload("res://Resources/Sounds/UI/ghost_a.ogg"),
	"e": preload("res://Resources/Sounds/UI/ghost_a.ogg"),
	"i": preload("res://Resources/Sounds/UI/ghost_a.ogg"),
	"o": preload("res://Resources/Sounds/UI/ghost_a.ogg"),
	"u": preload("res://Resources/Sounds/UI/ghost_a.ogg"),
	"consonant": preload("res://Resources/Sounds/UI/leveltransition.ogg")
}

onready var consonants = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n',
'p', 'q', 'r', 's', 't', 'v', 'x', 'y', 'z']

func _ready():
	volume_db = 0.0

func play_sound(sound_string):
	if not audio_effects.keys().has(sound_string):
		print("Sound string %s doesn't exist!" % sound_string)
		return

	stop()
	stream = audio_effects[sound_string]
	play()
