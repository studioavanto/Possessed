extends Sprite

export var spikes_on = true

func toggle_spikes():
	spikes_on = not spikes_on
	
	if spikes_on:
		$HurtBox.set_collision_layer_bit(2, true)
		print('Spikes on')
	else:
		$HurtBox.set_collision_layer_bit(2, false)
		print('Spikes off')
