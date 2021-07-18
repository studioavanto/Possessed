extends AnimatedSprite

export var spikes_on = true

func toggle_spikes():
	spikes_on = not spikes_on
	
	get_parent().play_sound("ansa_piikki")
	
	if spikes_on:
		animation = "ouchy"
		$HurtBox.set_collision_layer_bit(2, true)
	else:
		animation = "retract"
		$HurtBox.set_collision_layer_bit(2, false)

func toggle_on():
	toggle_spikes()
	
func toggle_off():
	toggle_spikes()

func _on_Button_toggle_off():
	toggle_spikes() # Replace with function body.

func _on_Button_toggle_on():
	toggle_spikes() # Replace with function body.
