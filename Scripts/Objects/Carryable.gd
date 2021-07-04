extends KinematicBody2D

export var throw_speed = 500.0
export var fall_speed = 1000.0
export var collidable = false
var is_being_carried = false
var y_speed = 0.0
var x_speed = 0.0
var facing = 1.0

func throw(direction, thrower_facing):
	x_speed = direction.x + throw_speed * thrower_facing
	y_speed = direction.y
	
	position.x += 20.0 * thrower_facing
	position.y -= 10.0

func stop_being_carried():
	if collidable:
		set_collision_layer_bit(0, true)
	is_being_carried = false

func carry_target():
	if is_being_carried:
		return false
	else:
		if collidable:
			set_collision_layer_bit(0, false)
		is_being_carried = true
		return true

func process_physics(delta):
	if (is_being_carried == false):
		var vect = move_and_slide(Vector2(x_speed, y_speed), Vector2(0, -1))

		if vect.x == 0.0:
			x_speed = 0.0

		if is_on_floor():
			x_speed = 0.0
			y_speed = 0.0
		else:
			y_speed += fall_speed * delta
	else:
		x_speed = 0.0
		y_speed = 0.0

func _physics_process(delta):
	process_physics(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
