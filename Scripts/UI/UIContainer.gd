extends CanvasLayer

var monologue = []
var level_name = []
var input_counter = 0
var can_proceed = true

func connect_character_to_ui(character):
	character.connect("character_value_changes", $CharacterCounter, "change_value")
	character.connect("character_portrait_changes", $CharacterCounter, "change_portrait")
	
func _ready():
	$ChangeLevelRect.connect("fade_in_completed", self, "screen_fade_in_done")
	$ChangeLevelRect.connect("fade_out_completed", self, "screen_fade_out_done")

func proceed():
	if can_proceed:
		print("can proceed")
		input_counter += 1
		can_proceed = false
		
		if input_counter == 1:
			$ChangeLevelRect.fade_out_active()
		elif input_counter == 2:
			$ChangeLevelRect.fade_out_scene()
			
func get_level_name(map_id):
	return ["hahaa", "hahaaaaa"]
	
func get_level_monologue(map_id):
	return ["höhöö", "höhöhöhöhöhö"]
	
func screen_fade_in_done():
	print('Fade in done')
	if input_counter == 0:
		get_parent().load_new_level()
		
	can_proceed = true
	
func screen_fade_out_done():
	print("Fade out done")
	if input_counter == 1:
		$ChangeLevelRect.fade_in_scene("level_name", get_level_name(get_parent().current_map_id))
	elif input_counter == 2:
		print('counter 2')
		get_parent().start_new_level()

func show_new_map(new_map):
	print("show new map")
	can_proceed = false
	input_counter = 0
	$ChangeLevelRect.fade_in_scene("monologue", get_level_monologue(new_map))
