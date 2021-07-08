extends Node

onready var audio_effects = {
	"ansa_piikki": [ preload("res://Resources/Sounds/Objects/ansapiikki.ogg"), 0.0 ],
	"boski_raahaus": [ preload("res://Resources/Sounds/Objects/boksiraahaus.ogg"), 0.0 ],
	"boksi_rikki": [ preload("res://Resources/Sounds/Objects/boksirikki.ogg"), 0.0 ],
	"kalteri_ovi": [ preload("res://Resources/Sounds/Objects/kalteriovi.ogg"), 0.0 ],
	"lattia_nappi": [ preload("res://Resources/Sounds/Objects/lattianappi.ogg"), 0.0 ],
	"object_fall": [ preload("res://Resources/Sounds/Objects/objectfall.ogg"), 0.0 ],
	"vipu": [ preload("res://Resources/Sounds/Objects/vipu.ogg"), 0.0 ],
	"game_over": [ preload("res://Resources/Sounds/UI/gameover.ogg"), 0.0 ],
	"level_transition": [ preload("res://Resources/Sounds/UI/leveltransition.ogg"), 0.0 ],
	"mark_as_possessed": [ preload("res://Resources/Sounds/UI/mark_as_possessed.ogg"), 0.0 ],
	"start_game": [ preload("res://Resources/Sounds/UI/startgame.ogg"), 0.0 ],
	"warp_to_host": [ preload("res://Resources/Sounds/UI/warp_to_host.ogg"), 0.0 ]
}

export var silenced = false

func play_sound(sound_string):
	if silenced:
		return

	if not audio_effects.keys().has(sound_string):
		print("Sound string %s doesn't exist!" % sound_string)
		return

	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = audio_effects[sound_string][0]
	$AudioStreamPlayer.volume_db = audio_effects[sound_string][1]
	$AudioStreamPlayer.play()
