extends Control

var fade_timing = 1.0
var current_active = "None"
# var tile_texture = preload("res://Resources/UI/background_frame.png")
var tile_texture = preload("res://Resources/UI/map_transition.png")

signal fade_in_completed
signal fade_out_completed

# Called when the node enters the scene tree for the first time.
func _ready():
	$Monologue.modulate = Color(1.0, 1.0, 1.0, 0.0)
	$Sprite.modulate = Color(1.0, 1.0, 1.0, 0.0)
	$TextureRect.modulate = Color(1.0, 1.0, 1.0, 0.0)
	$FadeInTween.connect("tween_all_completed", self, "fade_in_completed")
	$FadeOutTween.connect("tween_all_completed", self, "fade_out_completed")

func swap_to_tiles():
	$ScreenTexture.texture = tile_texture

func set_transparent():
	$ScreenTexture.modulate = Color(0.0, 0.0, 0.0, 0.0)
	$TextureRect.modulate = Color(0.0, 0.0, 0.0, 0.0)

func fade_in_completed():
	emit_signal("fade_in_completed")
	
func fade_out_completed():
	emit_signal("fade_out_completed")
	$Monologue/Timer.stop()
	$Monologue.set_visible_characters(1)
	
func fade_out_active():
	$FadeOutTween.interpolate_property(
		$Monologue,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		fade_timing,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$FadeOutTween.interpolate_property(
		$Sprite,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		fade_timing,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$FadeOutTween.start()

func fade_in_scene(state, message="", first = false):
	if state == "monologue":
		
		$Monologue.set_bbcode(message)
		$Monologue/Timer.start()

		$FadeInTween.interpolate_property(
			$ScreenTexture,
			"modulate",
			Color(1.0, 1.0, 1.0, 0.0),
			Color(1.0, 1.0, 1.0, 1.0),
			fade_timing,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN
		)

		$FadeInTween.interpolate_property(
			$Sprite,
			"modulate",
			Color(1.0, 1.0, 1.0, 0.0),
			Color(1.0, 1.0, 1.0, 1.0),
			fade_timing,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN
		)
		
		$FadeInTween.interpolate_property(
			$Monologue,
			"modulate",
			Color(1.0, 1.0, 1.0, 0.0),
			Color(1.0, 1.0, 1.0, 1.0),
			fade_timing,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN
		)
	
#	elif state == "level_name":
#		
#		$LevelTitle.set_text(message)
#		
#		$FadeInTween.interpolate_property(
#			$LevelTitle,
#			"modulate",
#			Color(1.0, 1.0, 1.0, 0.0),
#			Color(1.0, 1.0, 1.0, 1.0),
#			fade_timing,
#			Tween.TRANS_LINEAR,
#			Tween.EASE_IN
#		)
	
	$FadeInTween.start()

func fade_out_scene(first = false):
	if not first:
		$FadeOutTween.interpolate_property(
			$Monologue,
			"modulate",
			Color(1.0, 1.0, 1.0, 1.0),
			Color(1.0, 1.0, 1.0, 0.0),
			fade_timing,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN
		)
		
		$FadeOutTween.interpolate_property(
			$Sprite,
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
