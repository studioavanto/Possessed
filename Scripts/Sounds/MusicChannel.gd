extends AudioStreamPlayer

export var fade_timing = 0.05
export var transition_channel = false

func _ready():
	volume_db = -80.0
	$FadeOut.connect("tween_all_completed", self, "music_is_silenced") 

func fade_in():
	play()
	$FadeIn.interpolate_property(
		self,
		"volume_db",
		-80.0,
		0.0,
		fade_timing,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$FadeIn.start()

func fade_out():
	$FadeOut.interpolate_property(
		self,
		"volume_db",
		0.0,
		-80.0,
		fade_timing * 2,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	
	$FadeOut.start()

func music_is_silenced():
	stop()
	if !transition_channel:
		get_parent().start_next_song()	
