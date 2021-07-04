extends TextureRect

var fade_timing = 0.2
var current_active = "None"

# Called when the node enters the scene tree for the first time.
func _ready():
	$FadeOutTween.connect("tween_all_completed", self, "fade_out_completed")
	$FadeInTween.connect("tween_all_completed", self, "fade_in_completed")

func fade_out_completed():
	get_parent().get_parent().move_to_next_stage()

func fade_in_completed():
	get_parent().get_parent().destroy_current_map()
	
func fade_out_active():
	$FadeOutTween.interpolate_property(
		$ScreenTexture,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		fade_timing,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$FadeOutTween.start()

func fade_in_scene(state):
	
	if state == "intro":
		# $ScreenTexture.texture = intro_scene
		pass
	elif state == "monologue":
		# $ScreenTexture.texture = wakeup_scene
		pass
	elif state == "end_screen":
		# $ScreenTexture.texture = end_screen
		pass
		
	$FadeInTween.interpolate_property(
		$ScreenTexture,
		"modulate",
		Color(1.0, 1.0, 1.0, 0.0),
		Color(1.0, 1.0, 1.0, 1.0),
		fade_timing,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$FadeInTween.start()
