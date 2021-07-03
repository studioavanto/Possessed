extends KinematicBody2D

export var throw_speed = 500.0
export var fall_speed = 1000.0
var is_being_carried = false
var throw_x_speed = 0.0
var throw_y_speed = 0.0
var facing = 1.0
# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.

func throw(direction):

	throw_x_speed = direction.x + throw_speed*facing
	throw_y_speed = direction.y

func carry_target():
	if is_being_carried:
		return false
	else:
		return true

func _physics_process(delta):
	"""
	move_and_slide(Vector2(throw_x_speed, throw_y_speed))
	throw_y_speed += fall_speed
	if is_on_floor():
		throw_x_speed = 0.0
		throw_y_speed = 0.0
	"""
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
