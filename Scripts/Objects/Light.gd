extends Light2D

export var flicker_amount = 2.0
export var flicker_base = 0.5
onready var noise = OpenSimplexNoise.new()
var value = 0.0
const MAX_VALUE = 100000000
var max_alpha = 1.0
var fade_timing = 0.3

func _ready():
	randomize()
	value = randi() % MAX_VALUE

func _process(delta):
	value += 0.5
	if(value > MAX_VALUE):
		value = 0.0
	var alpha = min(((noise.get_noise_1d(value) + 1) / flicker_amount) + flicker_base, max_alpha)
	color = Color(color.r, color.g, color.b, alpha)

func fade_light_in():
	$Tween.interpolate_property(
		self,
		"max_alpha",
		0.0,
		1.0,
		fade_timing,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$Tween.start()

func fade_light_out():
	$Tween.interpolate_property(
		self,
		"max_alpha",
		1.0,
		0.0,
		fade_timing,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)

	$Tween.start()
