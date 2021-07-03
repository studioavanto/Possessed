extends Line2D

export var platform_speed = 200

var torward_point = 1
var wait = false

func _ready():
	$Timer.wait_time = 0.25
	$Timer.connect("timeout", self, "begin_movement")

func begin_movement():
	torward_point = (torward_point + 1) % 2
	wait = false

func _physics_process(delta):
	if wait:
		return

	$Platform.position = lerp($Platform.position, get_point_position(torward_point), 0.25)
	
	if $Platform.position == get_point_position(torward_point):
		wait = true
		$Timer.start()
