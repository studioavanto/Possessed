extends RichTextLabel

func _ready():
	self.set_bbcode("")

func set_text(message):
	self.set_bbcode(message)
