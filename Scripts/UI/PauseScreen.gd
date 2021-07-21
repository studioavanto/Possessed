extends TextureRect

func fade_in_pause_screen():
	$Tween.interpolate_property(
		self,
		"modulate",
		Color(1.0, 1.0, 1.0, 0.0),
		Color(1.0, 1.0, 1.0, 1.0),
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	$Tween.start()
	
func fade_out_pause_screen():
	$Tween.interpolate_property(
		self,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	$Tween.start()
