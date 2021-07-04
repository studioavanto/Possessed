extends Polygon2D

var dialog = ["Test text", "Second test text"]
var page = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$RichTextLabel.set_bbcode(dialog[page])
	$RichTextLabel.set_visible_characters(0)
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_Timer_timeout():
	$RichTextLabel.set_visible_characters($RichTextLabel.get_visible_characters()+1)
	
	if $RichTextLabel.get_visible_characters() > $RichTextLabel.get_total_character_count():
		
		if page < dialog.size():
			
			page += 1
			
			$RichTextLabel.set_bbcode(dialog[page])
			$RichTextLabel.set_visible_characters(0)
