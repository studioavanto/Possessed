extends StaticBody2D

export var door_on = true

func toggle_door():
	door_on = not door_on
	
	if door_on:
		set_collision_layer_bit(0, true)
		$AnimatedSprite.animation = "closing"
	else:
		set_collision_layer_bit(0, false)
		$AnimatedSprite.animation = "opening"

func _on_Button_toggle_off():
	toggle_door() 

func _on_Button_toggle_on():
	toggle_door()
