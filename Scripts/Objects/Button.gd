extends Node2D

export(Array, NodePath) var targets

signal toggle_on
signal toggle_off

var button_on = false

func get_weight_above():
	var areas = []
	
	for a in $CheckWeight.get_overlapping_areas():
		areas += a.get_parent().get_weight_above()

	return areas
	
func _ready():
	for target in targets:
		connect("toggle_on", get_node(target), "toggle_on")
		connect("toggle_off", get_node(target), "toggle_off")

func _on_CheckWeight_area_entered(area):
	if button_on:
		return
	
	button_on = true
	emit_signal("toggle_on")
	$ButtonSprite.animation = "pressed"

func _on_CheckWeight_area_exited(area):
	if not get_weight_above().empty():
		return
	
	button_on = false
	emit_signal("toggle_off")
	$ButtonSprite.animation = "default"
