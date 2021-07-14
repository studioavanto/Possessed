extends TextureRect

var intro_boxes = ["Alas!", "Alack!", "Oh nooooooooo!", "Gosh darn it!"]
var text_elem = 0

func _ready():
	set_text(intro_boxes[0])

func set_text(message):
	$RichTextLabel.set_bbcode(message)
	$RichTextLabel.set_visible_characters(0)

func _on_Timer_timeout():
	$RichTextLabel.set_visible_characters($RichTextLabel.get_visible_characters()+1)
	
	if $RichTextLabel.get_visible_characters() > $RichTextLabel.get_total_character_count():
		$RichTextLabel/Timer.stop()
		text_elem += 1
		
		if text_elem < len(intro_boxes):
			set_text(intro_boxes[text_elem])
			$RichTextLabel/Timer.start()
		else:
			$RichTextLabel/Timer.stop()
