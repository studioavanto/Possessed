extends Node

onready var audio_effects = {
	"ansa_piikki": [ preload("res://Resources/Sounds/Objects/ansapiikki.ogg"), -15.0 ],
	"boski_raahaus": [ preload("res://Resources/Sounds/Objects/boksiraahaus.ogg"), 0.0 ],
	"boksi_rikki": [ preload("res://Resources/Sounds/Objects/boksirikki.ogg"), 0.0 ],
	"kalteri_ovi": [ preload("res://Resources/Sounds/Objects/kalteriovi.ogg"), -15.0 ],
	"lattia_nappi": [ preload("res://Resources/Sounds/Objects/lattianappi.ogg"), -15.0 ],
	"object_fall": [ preload("res://Resources/Sounds/Objects/objectfall.ogg"), 0.0 ],
	"vipu": [ preload("res://Resources/Sounds/Objects/vipu.ogg"), 0.0 ],
	"game_over": [ preload("res://Resources/Sounds/UI/gameover.ogg"), -13.0 ],
	"level_transition": [ preload("res://Resources/Sounds/UI/leveltransition.ogg"), -13.0 ],
	"mark_as_possessed": [ preload("res://Resources/Sounds/Characters/mark_as_possessed.ogg"), -6.0 ],
	"start_game": [ preload("res://Resources/Sounds/UI/startgame.ogg"), -13.0 ],
	"buhaha": [ preload("res://Resources/Sounds/UI/buhaha.ogg"), -10.0 ],
	"warp_to_host": [ preload("res://Resources/Sounds/Characters/warp_to_host.ogg"), 8.0 ],
	"teleport": [ preload("res://Resources/Sounds/Objects/wizard_teleport.ogg"), -10.0 ],
}

export var silenced = false

func play_sound(sound_string):
	if silenced:
		return

	if not audio_effects.keys().has(sound_string):
		print("Sound string %s doesn't exist!" % sound_string)
		return

	if sound_string == "start_game":
		$AudioStreamPlayerSecond.stop()
		$AudioStreamPlayerSecond.stream = audio_effects["buhaha"][0]
		$AudioStreamPlayerSecond.volume_db = audio_effects["buhaha"][1]
		$AudioStreamPlayerSecond.play()

	if ["ansa_piikki", "kalteri_ovi"].has(sound_string):
		$AudioStreamPlayerSecond.stop()
		$AudioStreamPlayerSecond.stream = audio_effects["lattia_nappi"][0]
		$AudioStreamPlayerSecond.volume_db = audio_effects["lattia_nappi"][1]
		$AudioStreamPlayerSecond.play()

	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = audio_effects[sound_string][0]
	$AudioStreamPlayer.volume_db = audio_effects[sound_string][1]
	$AudioStreamPlayer.play()
