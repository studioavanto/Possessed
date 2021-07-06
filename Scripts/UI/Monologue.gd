extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_bbcode("This is all test stuff")
	self.set_visible_characters(0)
	$Timer.start()

func _on_Timer_timeout():
	self.set_visible_characters(self.get_visible_characters()+1)
	
	if self.get_visible_characters() > self.get_total_character_count():
		$Timer.stop()
