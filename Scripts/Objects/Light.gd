extends Light2D

export var flicker_amount = 2.0
export var flicker_base = 0.5
onready var noise = OpenSimplexNoise.new()
var value = 0.0
const MAX_VALUE = 100000000

func _ready():
	randomize()
	value = randi() % MAX_VALUE

func _process(delta):
	value += 0.5
	if(value > MAX_VALUE):
		value = 0.0
	var alpha = ((noise.get_noise_1d(value) + 1) / flicker_amount) + flicker_base
	color = Color(color.r, color.g, color.b, alpha)
