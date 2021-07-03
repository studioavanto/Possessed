extends KinematicBody2D

export var throw_speed = 500.0
export var fall_speed = 1000.0
var is_being_carried = false
var throw_x_speed = 0.0
var throw_y_speed = 0.0
var facing = 1.0
var being_passive = true
# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.

func throw(direction, thrower_facing):
	throw_x_speed = direction.x + throw_speed*thrower_facing
	throw_y_speed = direction.y
	position.x += 20.0*thrower_facing
	position.y -= 10.0

func stop_being_carried():
	set_collision_layer_bit(0,true)
	is_being_carried = false

func carry_target():
	if is_being_carried:
		return false
	else:
		set_collision_layer_bit(0,false)
		is_being_carried = true
		return true

func _physics_process(_delta):
	
	if(being_passive and is_being_carried == false):
		var vect = move_and_slide(Vector2(throw_x_speed, throw_y_speed),Vector2(0, -1))
		if vect.x == 0.0:
			throw_x_speed = 0.0
		if is_on_floor():
			throw_x_speed = 0.0
			throw_y_speed = 0.0
		throw_y_speed += fall_speed * _delta
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
