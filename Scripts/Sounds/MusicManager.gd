extends Node

onready var songs = [
	preload("res://Resources/Music/taikameibi_BG.ogg"),
	preload("res://Resources/Music/indyrick_BG.ogg"),
	preload("res://Resources/Music/theme_BG.ogg"),
	preload("res://Resources/Music/whimsy_BG.ogg"),
]

onready var wizard_clips = [
	preload("res://Resources/Music/taikameibi_VELHO.ogg"),
	preload("res://Resources/Music/indyrick_VELHO.ogg"),
	preload("res://Resources/Music/theme_VELHO.ogg"),
	preload("res://Resources/Music/whimsy_VELHO.ogg"),
]

onready var barbarian_clips = [
	preload("res://Resources/Music/taikameibi_barba.ogg"),
	preload("res://Resources/Music/indyrick_BARBA.ogg"),
	preload("res://Resources/Music/theme_BARBA.ogg"),
	preload("res://Resources/Music/whimsy_BARBA.ogg"),
]

onready var thief_clips = [
	preload("res://Resources/Music/taikameibi_THIEF.ogg"),
	preload("res://Resources/Music/indyrick_THIEF.ogg"),
	preload("res://Resources/Music/theme_THIEF.ogg"),
	preload("res://Resources/Music/whimsy_THIEF.ogg"),
]

var active_song = -1
var next_song = -1
var song_fade_out_time = 0.5
var active_character = -1

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
		0.0,
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
	
	fade_out_character_track()
	
	$Tween.start()

func start_new_song():
	if next_song == -1:
		return

	$AudioStreamPlayer.stop()
	$BarbarianMusic.stop()
	$ThiefMusic.stop()
	$WizardMusic.stop()

	$AudioStreamPlayer.stream = songs[next_song]
	$BarbarianMusic.stream = barbarian_clips[next_song]
	$ThiefMusic.stream = thief_clips[next_song]
	$WizardMusic.stream = wizard_clips[next_song]

	next_song = -1
	$AudioStreamPlayer.volume_db = 0.0
	$AudioStreamPlayer.play()
	$ThiefMusic.play()
	$BarbarianMusic.play()
	$WizardMusic.play()
