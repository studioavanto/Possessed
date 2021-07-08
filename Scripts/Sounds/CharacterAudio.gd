extends AudioStreamPlayer2D

onready var audio_effects = {
}

var walk_db = 0.0
var walk_counter = 0
var step_is_playing = false

onready var walk_sounds = [
]

func _ready():
	connect("finished", self, "footstep_has_played")

func footstep_has_played():
	step_is_playing = false

func play_footstep():
	if step_is_playing:
		return
	stop()
	stream = walk_sounds[walk_counter]
	volume_db = walk_db
	play()
	step_is_playing = true
	
	walk_counter = (walk_counter+1) % 4

func play_sound(sound_string):
	if not audio_effects.keys().has(sound_string):
		print("Sound string %s doesn't exist!" % sound_string)
		return

	stop()
	stream = audio_effects[sound_string][0]
	volume_db = audio_effects[sound_string][1]
	play()
