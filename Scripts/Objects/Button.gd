extends Node2D

signal toggle_on
signal toggle_off

func _on_CheckWeight_area_entered(area):
	emit_signal("toggle_on")
	$ButtonSprite.animation = "pressed"

func _on_CheckWeight_area_exited(area):
	emit_signal("toggle_off")
	$ButtonSprite.animation = "default"
