extends RichTextLabel

var regex = RegEx.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_bbcode("Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
	self.set_visible_characters(0)
	regex.compile("[A-Za-z]")
	# $Timer.start()

func _on_Timer_timeout():
	self.set_visible_characters(self.get_visible_characters()+1)
	print(get_bbcode())
	
	if self.get_visible_characters() >= self.get_total_character_count():
		$Timer.stop()
	else:
		var revealed_character = self.get_bbcode()[self.get_visible_characters() - 1]
		
		if regex.search(revealed_character):
			$MumbleAudio.play_random_sound()
