extends Node

onready var audio_effects = {
	"test_sound": preload("res://Resources/Sounds/Characters/kentan_vaihto_impact.wav")
}

func play_sound(sound_string):
	if not audio_effects.keys().has(sound_string):
		print("Sound string {0} doesn't exist!".format(sound_string))
		return

	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = audio_effects[sound_string]
	$AudioStreamPlayer.play()
