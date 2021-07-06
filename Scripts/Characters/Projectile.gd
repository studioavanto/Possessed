extends KinematicBody2D

var projectile_speed = 800
var has_been_used = false
var facing = 0

func _ready():
	$Tween2.connect("tween_all_completed", self, "destroy_projectile")

func set_facing(new_facing):
	facing = new_facing
	if facing == -1.0:
		scale.x = -1.0

func start_destroy_projectile():
	has_been_used = true
	$AnimatedSprite.animation = "destroy"
	$CPUParticles2D.emitting = true
	
	$Tween.interpolate_property(
		$AnimatedSprite,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		0.2,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$Tween2.interpolate_property(
		$CPUParticles2D,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$Tween.start()
	$Tween2.start()

func destroy_projectile():
	queue_free()

func _process(delta):
	if has_been_used:
		return

	var tmp_vec = move_and_slide(Vector2(facing * projectile_speed, 0.0))
	
	if tmp_vec.x == 0.0:
		start_destroy_projectile()
	
func _on_InteractArea_area_entered(area):
	if area.get_parent().get_instance_id() == get_parent().get_possessed_character_id():
		return
	
	if area.get_collision_layer_bit(4):
		area.get_parent().interact()
		start_destroy_projectile()
