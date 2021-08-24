extends TextureRect


var default_anchor_position = 0.0
var current_sway = 0.0
var sway_speed = 1.5
var offset = 5.0

func _ready():
	default_anchor_position = rect_position.y

func _process(delta):
	current_sway += sway_speed * delta
	
	rect_position.y = default_anchor_position + sin(current_sway) * offset
	
	if current_sway > 2*PI:
		current_sway = 0.0
