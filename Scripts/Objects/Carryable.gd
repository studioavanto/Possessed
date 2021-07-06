extends KinematicBody2D

export var throw_speed = 750.0
export var throw_speed_y = 250.0
export var fall_speed = 2750.0
export var collidable = false
var is_being_carried = false
var y_speed = 0.0
var x_speed = 0.0
var facing = 1.0
var has_space_above = true
var wait_to_drop = false

#func _ready():
	#$DropTimer.connect("timeout", self, "can_now_drop")

func get_total_weight():
	var all_areas = get_weight_above()

	var counted_areas = []
	var total_weight = 0

	for a in all_areas:
		if not counted_areas.has(a):
			total_weight += 1
			counted_areas.append(a)
	
	return total_weight

func get_weight_above():
	var areas = []
	
	for a in $CheckWeightArea.get_overlapping_areas():
		areas += a.get_parent().get_weight_above()

	areas.append(get_instance_id())

	return areas

func throw(direction, thrower_facing):
	x_speed = direction.x + throw_speed * thrower_facing
	y_speed = direction.y - throw_speed_y
	
	position.x += 20.0 * thrower_facing
	position.y -= 10.0

func stop_being_carried(character_dies = false):
	if character_dies:
		wait_to_drop = false
		#$DropTimer.start(0.1)

	if collidable:
		set_collision_layer_bit(0, true)

	is_being_carried = false

func carry_target():
	if is_being_carried or get_total_weight() > 1:
		return false
	else:
		if collidable:
			set_collision_layer_bit(0, false)
		is_being_carried = true
		return true

func process_physics(delta):
	var space_state = get_world_2d().direct_space_state
	var raycast_collisions = space_state.intersect_ray(position+Vector2(0,0), position+Vector2(0,-64), [self])
	if raycast_collisions.empty():
		 has_space_above = true
	else:
		has_space_above = false
	
	if (is_being_carried == false):
		var vect = move_and_slide(Vector2(x_speed, y_speed), Vector2(0, -1))

		if vect.x == 0.0:
			x_speed = 0.0

		if is_on_floor():
			x_speed = 0.0
			y_speed = 1.0
		else:
			y_speed += fall_speed * delta
	else:
		x_speed = 0.0
		y_speed = 1.0

func can_now_drop():
	wait_to_drop = false

func _physics_process(delta):
	if wait_to_drop:
		return

	process_physics(delta)
