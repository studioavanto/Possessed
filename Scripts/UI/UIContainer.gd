extends CanvasLayer

var input_counter = 0
var can_proceed = true
var first_not_done = true

var intro_animation = null
var fade_speed = 1.0

var fade_out = false
var fade_out_map = false
var start_continue = false

enum GamePhase { START, INTRO, GAME, END }
var current_phase = GamePhase.START

func set_phase_game():
	current_phase = GamePhase.GAME

func fade_out_death():
	fade_out = false
	$FadeOutBlack.interpolate_property(
		$BlackScreen,
		"modulate",
		Color(0.0, 0.0, 0.0, 0.0),
		Color(0.0, 0.0, 0.0, 1.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$FadeOutBlack.start()

func fade_out_complete():
	if start_continue:
		set_transparent()
		start_continue = false

	if not fade_out:
		if fade_out_map:
			get_parent().load_new_level()
		else:
			get_parent().load_new_level(true)

		fade_out = true
		if current_phase == GamePhase.GAME:
			get_parent().start_new_level()
		
		$FadeOutBlack.interpolate_property(
			$BlackScreen,
			"modulate",
			Color(0.0, 0.0, 0.0, 1.0),
			Color(0.0, 0.0, 0.0, 0.0),
			fade_speed,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN
		)
		
		$FadeOutBlack.start()

func tween_completed():
	if current_phase == GamePhase.START and input_counter == 1:
		$ChangeLevelRect.swap_to_tiles()
		current_phase = GamePhase.INTRO
		input_counter = 0
		proceed()

	if current_phase == GamePhase.INTRO:
		if input_counter == 2:
			get_parent().start_new_level()
			input_counter = 0
			current_phase = GamePhase.GAME

func connect_character_to_ui(character):
	character.connect("character_value_changes", $CharacterCounter, "change_value")
	character.connect("character_portrait_changes", $CharacterCounter, "change_portrait")

func _ready():
	$ChangeLevelRect.connect("fade_in_completed", self, "screen_fade_in_done")
	$ChangeLevelRect.connect("fade_out_completed", self, "screen_fade_out_done")
	$Tween.connect("tween_all_completed", self, "tween_completed")
	$FadeOutBlack.connect("tween_all_completed", self, "fade_out_complete")
	$TextBox.modulate = Color(1.0, 1.0, 1.0, 0.0)
	intro_animation = load("res://Scenes/GameObjects/UIScenes/IntroAnimation.tscn").instance()
	add_child(intro_animation)
	intro_animation.playing = false
	intro_animation.connect("animation_finished", self, "proceed")

func set_transparent():
	$TextureScreen.modulate = Color(0.0, 0.0, 0.0, 0.0)
	$StartPrompt.modulate = Color(0.0, 0.0, 0.0, 0.0)
	$ChangeLevelRect.set_transparent()

func fade_in_start_screen():
	$Tween.interpolate_property(
		$TextureScreen,
		"modulate",
		Color(0.0, 0.0, 0.0, 1.0),
		Color(1.0, 1.0, 1.0, 1.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$Tween.interpolate_property(
		$StartPrompt,
		"modulate",
		Color(0.0, 0.0, 0.0, 1.0),
		Color(1.0, 1.0, 1.0, 1.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)

	$Tween.start()

func fade_out_start_screen():
	$Tween.interpolate_property(
		$TextureScreen,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$Tween.interpolate_property(
		$StartPrompt,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)

	$Tween.start()

func start_intro():
	$Tween.interpolate_property(
		intro_animation,
		"modulate",
		Color(0.0, 0.0, 0.0, 0.0),
		Color(0.0, 0.0, 0.0, 1.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$Tween.start()

func fade_in_intro():
	$Tween.interpolate_property(
		intro_animation,
		"modulate",
		Color(0.0, 0.0, 0.0, 1.0),
		Color(1.0, 1.0, 1.0, 1.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$Tween.interpolate_property(
		$TextBox,
		"modulate",
		Color(0.0, 0.0, 0.0, 1.0),
		Color(1.0, 1.0, 1.0, 1.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$Tween.start()
	$TextBox/RichTextLabel/Timer.start()
	intro_animation.playing = true

func fade_out_intro():
	$ChangeLevelRect.fade_out_scene(true)
	intro_animation.playing = false
	
	$Tween.interpolate_property(
		intro_animation,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$Tween.interpolate_property(
		$TextBox,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$Tween.start()

func fade_in_end_screen():
	current_phase = GamePhase.END
	$TextureScreen.texture = load("res://Resources/UI/EndScreen.png")
	$Tween.interpolate_property(
		$TextureScreen,
		"modulate",
		Color(1.0, 1.0, 1.0, 0.0),
		Color(1.0, 1.0, 1.0, 1.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$Tween.start()

func proceed():
	match current_phase:
		GamePhase.START:
			get_parent().play_sound("start_game")
			get_parent().start_first_song()
			fade_out_start_screen()
			get_parent().load_new_map()
			input_counter = 1
		GamePhase.INTRO:
			if input_counter == 0:
				fade_in_intro()
				input_counter += 1 
			elif input_counter == 1:
				fade_out_intro()
				input_counter += 1
		GamePhase.GAME:
			if can_proceed:
				input_counter += 1
				can_proceed = false
				
				if input_counter == 1:
					$ChangeLevelRect.fade_out_scene()
		GamePhase.END:
			get_tree().quit()

func get_level_name(map_id):
	return $LevelTitles.level_titles[map_id]
	
func get_level_monologue(map_id):
	return $LevelMonologue.level_monologue[map_id]
	
func screen_fade_in_done():
	if input_counter == 0:
		get_parent().load_new_level()
	
	can_proceed = true
	
func screen_fade_out_done():
	if input_counter == 1:
		get_parent().start_new_level()

func show_new_map(new_map):
	can_proceed = false
	input_counter = 0
	$ChangeLevelRect.fade_in_scene("monologue", get_level_monologue(new_map), first_not_done)

	if first_not_done:
		first_not_done = false

func fade_straight_to_next_map():
	fade_out = false
	fade_out_map = true

	$FadeOutBlack.interpolate_property(
		$BlackScreen,
		"modulate",
		Color(0.0, 0.0, 0.0, 0.0),
		Color(0.0, 0.0, 0.0, 1.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$FadeOutBlack.start()

func fade_continue():
	fade_out = false
	fade_out_map = true
	start_continue = true

	$FadeOutBlack.interpolate_property(
		$BlackScreen,
		"modulate",
		Color(0.0, 0.0, 0.0, 0.0),
		Color(0.0, 0.0, 0.0, 1.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	
	$FadeOutBlack.start()

func fade_map_text(map_text):
	can_proceed = false
	input_counter = 0
	
	$ChangeLevelRect.fade_in_scene("monologue", map_text)
	
func set_level_name(text):
	$LevelTitle.set_text(text)

func fade_in_level_title():
	$TitleTween.interpolate_property(
		$LevelTitle,
		"modulate",
		Color(1.0, 1.0, 1.0, 0.0),
		Color(1.0, 1.0, 1.0, 1.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$TitleTween.start()
	
func fade_out_level_title():
	$TitleTween.interpolate_property(
		$LevelTitle,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		fade_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$TitleTween.start()

func fade_in_pause_screen():
	$PauseScreen.fade_in_pause_screen()

func fade_out_pause_screen():
	$PauseScreen.fade_out_pause_screen()
