extends RichTextLabel

func _ready():
	$Timer.start() # Replace with function body.

func _on_Timer_timeout():
	if self.get_visible_characters() == 0:
		self.set_visible_characters(self.get_total_character_count())
	else:
		self.set_visible_characters(0)
