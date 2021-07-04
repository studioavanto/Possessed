extends Node2D

signal toggle_on
signal toggle_off

var flipped = false

func toggle_switch():
	flipped = not flipped
	
	if flipped == true:
		emit_signal("toggle_on")
		
	if flipped == false:
		emit_signal("toggle_off")

func interact():
	toggle_switch()
