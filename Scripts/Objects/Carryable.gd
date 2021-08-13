extends KinematicBody2D

export var fall_speed = 2750.0
export var collidable = false
export var terminal_velocity = 800
var is_being_carried = false
var y_speed = 0.0
var x_speed = 0.0
var on_air = false

var teleport_location = null
var teleport_timing = 0.01
var teleport_particles = null

func _ready():
	$TeleportTween.connect("tween_all_completed", self, "teleport_happens")
	teleport_particles = preload("res://Scenes/GameObjects/ParticleEffects/TeleportParticles.tscn").instance()
	add_child(teleport_particles)

func set_terminal_velocity():
	if y_speed > terminal_velocity:
		y_speed = terminal_velocity

func get_character_sprite():
	return $Sprite

func toggle_hitboxes(value):
	$HitBox.disabled = not value

func teleport_happens():
	if teleport_location != null:
		position = teleport_location
		teleport_location = null
		toggle_hitboxes(false)
		teleport_particles.emitting = true

		$TeleportTween.interpolate_property(
			get_character_sprite(),
			"modulate",
			Color(1.0, 1.0, 1.0, 0.0),
			Color(1.0, 1.0, 1.0, 1.0),
			teleport_timing,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN
		)
		$TeleportTween.start()
	else:
		toggle_hitboxes(true)

func trigger_teleport(new_location):
	teleport_location = new_location
	$TeleportTween.interpolate_property(
		get_character_sprite(),
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
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
	return $IsSpaceAbove.get_overlapping_bodies().empty()

func process_physics(delta):
	if (is_being_carried == false):
		if is_on_floor():
			if on_air and y_speed > terminal_velocity - 20:
				on_air = false
			x_speed = 0.0
			y_speed = 10.0
		else:
			y_speed += fall_speed * delta
			on_air = true
	else:
		x_speed = 0.0
		y_speed = 10.0
	
	set_terminal_velocity()
	
	if move_and_slide(Vector2(x_speed, y_speed), Vector2(0, -1)).x == 0.0:
		x_speed = -sign(x_speed) * 4

func _physics_process(delta):
	if get_parent().is_paused():
		return
	process_physics(delta)

func teleport_object(area):
	area.get_parent().start_destroy_projectile()
	get_parent().teleport_character(self)
