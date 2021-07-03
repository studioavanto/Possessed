extends Line2D

export var platform_speed = 40
var torward_point = 1
var wait = false
var stop = false

func _ready():
	$Timer.wait_time = 1.0
	$Timer.connect("timeout", self, "begin_movement")

func begin_movement():
	torward_point = (torward_point + 1) % 2
	wait = false

func toggle_platform():
	stop = not stop

func _physics_process(delta):
	if wait or stop:
		return

	$Platform.position -= ($Platform.position - get_point_position(torward_point)).normalized() * delta * platform_speed
	
	if ($Platform.position - get_point_position(torward_point)).length() < 10:
		wait = true
		$Timer.start()
