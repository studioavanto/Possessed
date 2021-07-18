extends Node

onready var other = [
	preload("res://Resources/Music/introtrack.ogg"),
	preload("res://Resources/Music/outroteema.ogg")
	]

onready var songs = [
	preload("res://Resources/Music/taikameibi_BG.ogg"),
	preload("res://Resources/Music/indyrick_BG.ogg"),
	preload("res://Resources/Music/theme_BG.ogg"),
	preload("res://Resources/Music/whimsy_BG.ogg"),
]

onready var wizard_clips = [
	preload("res://Resources/Music/taikameibi_velho.ogg"),
	preload("res://Resources/Music/indyrick_velho.ogg"),
	preload("res://Resources/Music/theme_velho.ogg"),
	preload("res://Resources/Music/whimsy_velho.ogg"),
]

onready var barbarian_clips = [
	preload("res://Resources/Music/taikameibi_barba.ogg"),
	preload("res://Resources/Music/indyrick_barba.ogg"),
	preload("res://Resources/Music/theme_barba.ogg"),
	preload("res://Resources/Music/whimsy_barba.ogg"),
]

onready var thief_clips = [
	preload("res://Resources/Music/taikameibi_thief.ogg"),
	preload("res://Resources/Music/indyrick_thief.ogg"),
	preload("res://Resources/Music/theme_thief.ogg"),
	preload("res://Resources/Music/whimsy_thief.ogg"),
]

var active_song = -1
var next_song = -1
var song_fade_out_time = 0.3
var slow_fade_out = 10.0
var active_character = -1

var intro_vol = -7.0
var outro_vol = -15.0
var song_vol = [ 0.0, 0.0, 3.0, 0.0 ]

func _ready():
	$Tween.connect("tween_all_completed", self, "start_new_song")
	$WizardMusic.volume_db = -80.0
	$BarbarianMusic.volume_db = -80.0
	$ThiefMusic.volume_db = -80.0

func change_active_character(new_active_character):
	if new_active_character == active_character:
		return
	
	if active_character == -1:
		fade_in_character_track(new_active_character)
	elif new_active_character == -1:
		fade_out_character_track()
	else:
		fade_in_out_character_track(new_active_character)
	
	active_character = new_active_character

func current_active_track(character = -2):
	if character == -2:
		character = active_character
		
	if character == 1:
		return $BarbarianMusic
	elif character == 2:
		return $ThiefMusic
	elif character == 3:
		return $WizardMusic

	return null

func fade_out_character_track():
	var active_track = current_active_track()
	
	$FadeTween.interpolate_property(
		active_track,
		"volume_db",
		get_current_vol(),
		-80.0,
		song_fade_out_time,
		Tween.TRANS_EXPO,
		Tween.EASE_IN_OUT
	)
	$FadeTween.start()

func fade_in_character_track(new_active_character):
	var active_track = current_active_track(new_active_character)
	
	$FadeTween.interpolate_property(
		active_track,
		"volume_db",
		-80.0,
		0.0,
		song_fade_out_time,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	$FadeTween.start()
	
func fade_in_out_character_track(new_active_character):
	var active_track = current_active_track()
	var new_active_track = current_active_track(new_active_character)
	
	$FadeTween.interpolate_property(
		active_track,
		"volume_db",
		0.0,
		-80.0,
		song_fade_out_time,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	
	$FadeTween.interpolate_property(
		new_active_track,
		"volume_db",
		-80.0,
		0.0,
		song_fade_out_time,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	
	$FadeTween.start()

func change_song(new_song):
	if new_song == active_song:
		return
	
	next_song = new_song

	if new_song == -1:
		fade_song_out(true)
		return
	elif active_song == -1 or [10,11].has(active_song):
		start_new_song()
		return

	fade_song_out()

func get_current_vol():
	if active_song == 10:
		return intro_vol
	elif active_song == 11:
		return outro_vol
	else:
		return song_vol[active_song]

func fade_song_out(slow = false):
	var fade_out_t = song_fade_out_time
	if slow:
		fade_out_t = slow_fade_out
	
	$Tween.interpolate_property(
		$AudioStreamPlayer,
		"volume_db",
		get_current_vol(),
		-80.0,
		fade_out_t,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
	)
	
	if active_song != -1: 
		fade_out_character_track()
	
	$Tween.start()

func start_new_song():
	if next_song == -1:
		return
	
	active_song = next_song
	next_song = -1

	if [10, 11].has(active_song):
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.stream = other[active_song-10]
		$AudioStreamPlayer.volume_db = get_current_vol()
		$AudioStreamPlayer.play()
		print("Play")
		return

	$AudioStreamPlayer.stop()
	$BarbarianMusic.stop()
	$ThiefMusic.stop()
	$WizardMusic.stop()

	$AudioStreamPlayer.stream = songs[active_song]
	$BarbarianMusic.stream = barbarian_clips[active_song]
	$ThiefMusic.stream = thief_clips[active_song]
	$WizardMusic.stream = wizard_clips[active_song]

	$AudioStreamPlayer.volume_db = get_current_vol()
	$AudioStreamPlayer.play()
	$ThiefMusic.play()
	$BarbarianMusic.play()
	$WizardMusic.play()

