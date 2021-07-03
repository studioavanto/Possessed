extends Sprite

export var spikes_on = true

func toggle_spikes():
	spikes_on = not spikes_on
	
	if spikes_on:
		$HurtBox.set_collision_layer_bit(2, true)
	else:
		$HurtBox.set_collision_layer_bit(2, false)

func _on_Button_toggle_off():
	toggle_spikes() # Replace with function body.

func _on_Button_toggle_on():
	toggle_spikes() # Replace with function body.
