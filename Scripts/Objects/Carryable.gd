extends KinematicBody2D

var is_being_carried = false
# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.

func carry_target():
	if is_being_carried:
		return false
	else:
		return true

func _physics_process(delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
