extends Node

onready var songs = [
	preload("res://Sounds/Music/testiribale1.wav"),
	preload("res://Sounds/Music/testiribale2.wav"),
	preload("res://Sounds/Music/testiribale3.wav"),
	preload("res://Sounds/Music/testiribale4.wav")
]

onready var transitions = [
	preload("res://Sounds/Music/testiribale1alt.wav"),
	preload("res://Sounds/Music/testiribale2alt.wav"),
	preload("res://Sounds/Music/testiribale3alt.wav"),
	preload("res://Sounds/Music/testiribale4alt.wav")
]

var active_song = -1
var next_song = -1

var transition = false
var wait_to_next = false

var bpm: int = 120

func _ready():
	$Transition_1.volume_db = -80.0
	$Transition_2.volume_db = -80.0
	$Song.volume_db = -80.0
	$Metronome.connect("timeout", self, "one_bar")
	$Metronome.start(4*4 * 60.0 / bpm)
	$EndMusic.connect("timeout", self, "fade_out_active")

func change_song(new_song):
	if new_song == active_song:
		return
		
	next_song = new_song
		
	if active_song == -1 or transition:
		start_next_song()
	else:
		start_transition_next_song()

func start_transition_next_song():
	print("Start transition")
	transition = true
	
	$Transition_1.set_stream(transitions[active_song])
	$Transition_2.set_stream(transitions[next_song])
	
	if ($Metronome.time_left < $Song.fade_timing):
		wait_to_next = true
		$EndMusic.start($Metronome.wait_time + $Metronome.time_left -  $Song.fade_timing)
	else:
		$EndMusic.start($Metronome.time_left - $Song.fade_timing)

func start_next_song():
	print("Start next song")
	$Song.set_stream(songs[next_song])
	$EndMusic.start($Metronome.time_left - $Song.fade_timing)

func one_bar():
	if next_song == -1:
		return
	elif wait_to_next:
		wait_to_next = false
	else:
		change_music()

func change_music():
	print("Changing music")
	if transition:
		$Transition_1.volume_db = 0.0
		$Transition_2.volume_db = 0.0
		$Transition_1.play()
		$Transition_2.play()
		transition = false
	else:
		$Song.volume_db = 0.0
		$Song.play()
		active_song = next_song
		next_song = -1

func fade_out_active():
	print("Fade out active sound")
	if transition:
		$Song.fade_out()
	else:
		$Transition_1.fade_out()
		$Transition_2.fade_out()
