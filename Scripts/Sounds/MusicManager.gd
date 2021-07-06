extends Node

onready var songs = [
	preload("res://Resources/Music/OST_0.ogg"),
	preload("res://Resources/Music/OST_0.ogg"),
	preload("res://Resources/Music/OST_0.ogg"),
	preload("res://Resources/Music/OST_0.ogg"),
	preload("res://Resources/Music/OST_0.ogg")
]

var active_song = -1
var next_song = -1
var song_fade_out_time = 0.5

func _ready():
	$Tween.connect("tween_all_completed", self, "start_new_song")

func change_song(new_song):
	if new_song == active_song:
		return
	
	next_song = new_song

	if active_song == -1:
		start_new_song()
		return

	fade_song_out()

func fade_song_out():
	$Tween.interpolate_property(
		$AudioStreamPlayer,
		"volume_db",
		0.0,
		-80.0,
		song_fade_out_time,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$Tween.start()

func start_new_song():
	if next_song == -1:
		return

	$AudioStreamPlayer.stream = songs[next_song]
	next_song = -1
	$AudioStreamPlayer.volume_db = 0.0
	$AudioStreamPlayer.play()
