extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_bbcode("Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
	self.set_visible_characters(0)
	# $Timer.start()

func _on_Timer_timeout():
	self.set_visible_characters(self.get_visible_characters()+1)
	
	# TODO: get last character, play appropriate sound
	
	if self.get_visible_characters() > self.get_total_character_count():
		$Timer.stop()
