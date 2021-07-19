extends "res://Scripts/Characters/PossessCharacter.gd"

export var dash_speed = 950
export var dash_time = 0.25
export var dash_cooldown = 0.05

var dash_recovery = false
var can_dash = true
var old_speed = 0.0

func _ready():
	$DashTimer.connect("timeout", self, "end_dash")

func swap_facing():
	if character_state != CharacterState.SPECIAL:
		.swap_facing()

func end_dash():
	if dash_recovery:
		can_dash = true
		dash_recovery = false
	else:
		x_speed = old_speed
		character_state = CharacterState.IDLE
	
func process_special():
	if can_dash:
		character_state = CharacterState.SPECIAL
		can_dash = false
		$CharacterAudio.play_sound("dash")
		$DashTimer.start(dash_time)
		old_speed = x_speed

func special_physics_process():
	y_speed = 0.0
	x_speed = dash_speed * facing

func get_id():
	return 2

func process_physics(delta):
	.process_physics(delta)
	
	if is_on_floor() and not can_dash and not dash_recovery and character_state != CharacterState.SPECIAL:
		dash_recovery = true
		$DashTimer.start(dash_cooldown)
