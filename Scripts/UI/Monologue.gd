extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	$RichTextLabel.set_bbcode("none")
	$RichTextLabel.set_visible_characters(0)
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_Timer_timeout():
	$RichTextLabel.set_visible_characters($RichTextLabel.get_visible_characters()+1)
	
	if $RichTextLabel.get_visible_characters() > $RichTextLabel.get_total_character_count():
		
		$RichTextLabel.set_bbcode("placeholder")
		$RichTextLabel.set_visible_characters(0)
