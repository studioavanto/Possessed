extends AnimatedSprite

export var spikes_on = true

func toggle_spikes():
	spikes_on = not spikes_on
	
	if spikes_on:
		animation = "ouchy"
		$HurtBox.set_collision_layer_bit(2, true)
	else:
		animation = "retract"
		$HurtBox.set_collision_layer_bit(2, false)

func _on_Button_toggle_off():
	toggle_spikes() # Replace with function body.

func _on_Button_toggle_on():
	toggle_spikes() # Replace with function body.
