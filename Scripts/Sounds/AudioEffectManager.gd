extends Node

onready var audio_effects = {
	"ansa_piikki": [ preload("res://Resources/Sounds/Objects/ansapiikki.wav"), 0.0 ],
	"boski_raahaus": [ preload("res://Resources/Sounds/Objects/boksiraahaus.wav"), 0.0 ],
	"boksi_rikki": [ preload("res://Resources/Sounds/Objects/boksirikki.wav"), 0.0 ],
	"kalteri_ovi": [ preload("res://Resources/Sounds/Objects/kalteriovi.wav"), 0.0 ],
	"lattia_nappi": [ preload("res://Resources/Sounds/Objects/Lattianappi.wav"), 0.0 ],
	"object_fall": [ preload("res://Resources/Sounds/Objects/objectfall.wav"), 0.0 ],
	"vipu": [ preload("res://Resources/Sounds/Objects/vipu.wav"), 0.0 ],
}

func play_sound(sound_string):
	if not audio_effects.keys().has(sound_string):
		print("Sound string {0} doesn't exist!".format(sound_string))
		return

	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = audio_effects[sound_string][0]
	$AudioStreamPlayer.volume_db = audio_effects[sound_string][1]
	$AudioStreamPlayer.play()
