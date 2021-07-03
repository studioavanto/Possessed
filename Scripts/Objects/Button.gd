extends Node2D

signal toggle_on
signal toggle_off

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_CheckWeight_area_entered(area):
	emit_signal("toggle_on")

func _on_CheckWeight_area_exited(area):
	emit_signal("toggle_off")
