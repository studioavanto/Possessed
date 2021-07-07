extends Line2D

export var platform_speed = 40
export var stop = false
var torward_point = 1
var wait = false

func _ready():
	$Timer.wait_time = 1.0
	$Timer.connect("timeout", self, "begin_movement")

func get_weighting_objects():
	var objects = []
	var counted_objects = []
	
	for a in $Platform/CheckWeightArea.get_overlapping_areas():
		objects += a.get_parent().get_weight_above()

	for o in objects:
		if not counted_objects.has(o):
			counted_objects.append(o)

	return counted_objects

func move_all_objects_on_top(move_speed):
	var objects = get_weighting_objects()
	for o in objects: 
		instance_from_id(o).position.x += move_speed.x
		instance_from_id(o).position.y += move_speed.y

func begin_movement():
	torward_point = (torward_point + 1) % 2
	wait = false

func toggle_platform():
	stop = not stop

func _physics_process(delta):
	if wait or stop:
		return

	var move_speed = -($Platform.position - get_point_position(torward_point)).normalized() * delta * platform_speed
	$Platform.position += move_speed
	move_all_objects_on_top(move_speed)
	
	if ($Platform.position - get_point_position(torward_point)).length() < 10:
		wait = true
		$Timer.start()


func _on_Button_toggle_off():
	toggle_platform()

func _on_Button_toggle_on():
	toggle_platform()
