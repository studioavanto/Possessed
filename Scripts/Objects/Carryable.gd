extends KinematicBody2D

export var fall_speed = 2750.0
export var collidable = false
var is_being_carried = false
var y_speed = 0.0
var x_speed = 0.0

var teleport_location = null
var teleport_timing = 0.1

func _ready():
	$TeleportTimer.connect("timeout", self, "teleport_happens")

func get_character_sprite():
	return $Sprite

func teleport_happens():
	position = teleport_location
	$CPUParticles2D.emitting = true
	$TeleportTween.interpolate_property(
		get_character_sprite(),
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 1.0),
		teleport_timing,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$TeleportTween.start()

func trigger_teleport(new_location):
	teleport_location = new_location
	$TeleportTimer.start(teleport_timing)
	$TeleportTween.interpolate_property(
		get_character_sprite(),
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 1.0),
		teleport_timing,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$TeleportTween.start()

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
	x_speed = direction.x
	y_speed = direction.y
	
	position.x += 20.0 * thrower_facing
	position.y -= 10.0

func stop_being_carried():
	if collidable:
		set_collision_layer_bit(0, true)

	is_being_carried = false

func carry_target():
	if is_being_carried or not has_space_above() or get_total_weight() > 1:
		return false
	else:
		if collidable:
			set_collision_layer_bit(0, false)
		is_being_carried = true
		return true

func has_space_above():
	print( $IsSpaceAbove.get_overlapping_bodies())
	return $IsSpaceAbove.get_overlapping_bodies().empty()

func process_physics(delta):
	if (is_being_carried == false):
		if is_on_floor():
			x_speed = 0.0
			y_speed = 10.0
		else:
			y_speed += fall_speed * delta
	else:
		x_speed = 0.0
		y_speed = 10.0
	
	if move_and_slide(Vector2(x_speed, y_speed), Vector2(0, -1)).x == 0.0:
		x_speed = 0.0

func _physics_process(delta):
	process_physics(delta)

func teleport_object(area):
	area.get_parent().start_destroy_projectile()
	get_parent().teleport_character(self)
