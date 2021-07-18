extends Node2D

export(NodePath) var target

signal toggle_on
signal toggle_off

func _ready():
	if target != null:
		connect("toggle_on", get_node(target), "toggle_on")
		connect("toggle_off", get_node(target), "toggle_off")

func _on_CheckWeight_area_entered(area):
	emit_signal("toggle_on")
	$ButtonSprite.animation = "pressed"

func _on_CheckWeight_area_exited(area):
	emit_signal("toggle_off")
	$ButtonSprite.animation = "default"
