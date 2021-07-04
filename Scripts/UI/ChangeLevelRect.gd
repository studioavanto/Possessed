extends Control

var fade_timing = 1.0
var current_active = "None"

signal fade_in_completed
signal fade_out_completed

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextBox.modulate = Color(1.0, 1.0, 1.0, 0.0)
	$ScreenTexture.modulate = Color(1.0, 1.0, 1.0, 0.0)
	$FadeInTween.connect("tween_all_completed", self, "fade_in_completed")
	$FadeOutTween.connect("tween_all_completed", self, "fade_out_completed")
	
func fade_in_completed():
	emit_signal("fade_in_completed")
	
func fade_out_completed():
	emit_signal("fade_out_completed")
	
func fade_out_active():
	$FadeOutTween.interpolate_property(
		$TextBox,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		fade_timing,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$FadeOutTween.start()

func fade_in_scene(state, message=""):
	
	if state == "intro":
		# $ScreenTexture.texture = intro_scene
		pass
	elif state == "monologue":
		
		$FadeInTween.interpolate_property(
		$ScreenTexture,
		"modulate",
		Color(1.0, 1.0, 1.0, 0.0),
		Color(1.0, 1.0, 1.0, 1.0),
		fade_timing,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	elif state == "level_name":
		pass
	elif state == "end_screen":
		# $ScreenTexture.texture = end_screen
		pass
		
	$FadeInTween.interpolate_property(
		$TextBox,
		"modulate",
		Color(1.0, 1.0, 1.0, 0.0),
		Color(1.0, 1.0, 1.0, 1.0),
		fade_timing,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$FadeInTween.start()

func fade_out_scene():
	$FadeOutTween.interpolate_property(
		$TextBox,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		fade_timing,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
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
