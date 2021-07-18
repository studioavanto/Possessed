extends AudioStreamPlayer

onready var audio_effects = {
	"a": preload("res://Resources/Sounds/UI/ghost_a.ogg"),
	"e": preload("res://Resources/Sounds/UI/ghost_e.ogg"),
	"i": preload("res://Resources/Sounds/UI/ghost_i.ogg"),
	"o": preload("res://Resources/Sounds/UI/ghost_o.ogg"),
	"u": preload("res://Resources/Sounds/UI/ghost_u.ogg"),
	"ä": preload("res://Resources/Sounds/UI/ghost_ae.ogg"),
	"ö": preload("res://Resources/Sounds/UI/ghost_oe.ogg"),
	"y": preload("res://Resources/Sounds/UI/ghost_y.ogg")
}

onready var consonants = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n',
'p', 'q', 'r', 's', 't', 'v', 'x', 'y', 'z']

func _ready():
	volume_db = -18.0

func play_sound(sound_string):
	if not audio_effects.keys().has(sound_string):
		print("Sound string %s doesn't exist!" % sound_string)
		return

	stop()
	stream = audio_effects[sound_string]
	play()
	
func play_random_sound():
	var letter = ["a", "e", "i", "o", "u", "y"][randi() % 6]
	stop()
	stream = audio_effects[letter]
	play()
