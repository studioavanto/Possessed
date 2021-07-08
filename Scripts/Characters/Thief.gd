extends "res://Scripts/Characters/PossessCharacter.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func process_special():
	if can_dash:
		character_state = CharacterState.DASHING
		can_dash = false
		$AnimatedSprite.animation = "dash"
		$CharacterAudio.play_sound("dash")
	
func get_id():
	return 2

