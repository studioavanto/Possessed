extends Node2D

signal toggle_on
signal toggle_off

var flipped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func toggle_switch():
	flipped = not flipped
	
	if flipped == true:
		emit_signal("toggle_on")
		
	if flipped == false:
		emit_signal("toggle_off")

func interact():
	toggle_switch()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
