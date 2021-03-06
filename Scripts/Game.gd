extends Node2D

enum GameState { CONTROL_PLAYER, CONTROL_PAUSE, CONTROL_NULL, CONTROL_CUTSCENE }
enum MapEnum { 
	START_GAME,
	TEST_ILMO, TEST_VILLE, TEST_JOONAS, TEST_JOHANNES, 
	MAP_1_1, MAP_1_2, MAP_1_3, MAP_1_4, MAP_1_5, MAP_1_6, 
	MAP_2_1, MAP_2_2, MAP_2_3, MAP_2_4, MAP_2_5, MAP_2_6, 
	MAP_3_1, MAP_3_2, MAP_3_3, MAP_3_4, MAP_3_5, MAP_3_6, 
	MAP_4_1, MAP_4_2, MAP_4_3, MAP_4_4, MAP_4_5, MAP_4_6, 
	MAP_5_1, MAP_5_2, MAP_5_3, MAP_5_4, MAP_5_5, MAP_5_6, 
	NO_SAVE, OVERRIDE_SAVE
	}

var final_map_dict = {
	MapEnum.TEST_ILMO: "res://Scenes/Maps/TestMaps/TestIlmo.tscn",
	MapEnum.TEST_VILLE: "res://Scenes/Maps/TestMaps/TestVille.tscn",
	MapEnum.TEST_JOHANNES: "res://Scenes/Maps/TestMaps/TestJohannes.tscn",
	MapEnum.TEST_JOONAS: "res://Scenes/Maps/TestMaps/TestJoonas.tscn",
	MapEnum.MAP_1_1: "res://Scenes/Maps/FinalMaps/Map1_1.tscn",
	MapEnum.MAP_1_2: "res://Scenes/Maps/FinalMaps/Map1_2.tscn",
	MapEnum.MAP_1_3: "res://Scenes/Maps/FinalMaps/Map1_3.tscn",
	MapEnum.MAP_1_4: "res://Scenes/Maps/FinalMaps/Map1_4.tscn",
	MapEnum.MAP_1_5: "res://Scenes/Maps/FinalMaps/Map1_5.tscn",
	MapEnum.MAP_1_6: "res://Scenes/Maps/FinalMaps/Map1_6.tscn",
	MapEnum.MAP_2_1: "res://Scenes/Maps/FinalMaps/Map2_1.tscn",
	MapEnum.MAP_2_2: "res://Scenes/Maps/FinalMaps/Map2_2.tscn",
	MapEnum.MAP_2_3: "res://Scenes/Maps/FinalMaps/Map2_3.tscn",
	MapEnum.MAP_2_4: "res://Scenes/Maps/FinalMaps/Map2_4.tscn",
	MapEnum.MAP_2_5: "res://Scenes/Maps/FinalMaps/Map2_5.tscn",
	MapEnum.MAP_2_6: "res://Scenes/Maps/FinalMaps/Map2_6.tscn",
	MapEnum.MAP_3_1: "res://Scenes/Maps/FinalMaps/Map3_1.tscn",
	MapEnum.MAP_3_2: "res://Scenes/Maps/FinalMaps/Map3_2.tscn",
	MapEnum.MAP_3_3: "res://Scenes/Maps/FinalMaps/Map3_3.tscn",
	MapEnum.MAP_3_4: "res://Scenes/Maps/FinalMaps/Map3_4.tscn",
	MapEnum.MAP_3_5: "res://Scenes/Maps/FinalMaps/Map3_5.tscn",
	MapEnum.MAP_3_6: "res://Scenes/Maps/FinalMaps/Map3_6.tscn",
	MapEnum.MAP_4_1: "res://Scenes/Maps/FinalMaps/Map4_1.tscn",
	MapEnum.MAP_4_2: "res://Scenes/Maps/FinalMaps/Map4_2.tscn",
	MapEnum.MAP_4_3: "res://Scenes/Maps/FinalMaps/Map4_3.tscn",
	MapEnum.MAP_4_4: "res://Scenes/Maps/FinalMaps/Map4_4.tscn",
	MapEnum.MAP_4_5: "res://Scenes/Maps/FinalMaps/Map4_5.tscn",
	MapEnum.MAP_4_6: "res://Scenes/Maps/FinalMaps/Map4_6.tscn",
	MapEnum.MAP_5_1: "res://Scenes/Maps/FinalMaps/Map5_1.tscn",
	MapEnum.MAP_5_2: "res://Scenes/Maps/FinalMaps/Map5_2.tscn",
	MapEnum.MAP_5_3: "res://Scenes/Maps/FinalMaps/Map5_3.tscn",
	MapEnum.MAP_5_4: "res://Scenes/Maps/FinalMaps/Map5_4.tscn",
	MapEnum.MAP_5_5: "res://Scenes/Maps/FinalMaps/Map5_5.tscn",
	MapEnum.MAP_5_6: "res://Scenes/Maps/FinalMaps/Map5_6.tscn"
}

var map_music = {
	MapEnum.TEST_ILMO: 0,
	MapEnum.TEST_VILLE: 0,
	MapEnum.TEST_JOHANNES: 0,
	MapEnum.TEST_JOONAS: 0,
	MapEnum.MAP_1_1: 2,
	MapEnum.MAP_1_2: 2,
	MapEnum.MAP_1_3: 2,
	MapEnum.MAP_1_4: 2,
	MapEnum.MAP_1_5: 2,
	MapEnum.MAP_1_6: 2,
	MapEnum.MAP_2_1: 1,
	MapEnum.MAP_2_2: 1,
	MapEnum.MAP_2_3: 1,
	MapEnum.MAP_2_4: 1,
	MapEnum.MAP_2_5: 1,
	MapEnum.MAP_2_6: 1,
	MapEnum.MAP_3_1: 0,
	MapEnum.MAP_3_2: 0,
	MapEnum.MAP_3_3: 0,
	MapEnum.MAP_3_4: 0,
	MapEnum.MAP_3_5: 0,
	MapEnum.MAP_3_6: 0,
	MapEnum.MAP_4_1: 3,
	MapEnum.MAP_4_2: 3,
	MapEnum.MAP_4_3: 3,
	MapEnum.MAP_4_4: 3,
	MapEnum.MAP_4_5: 3,
	MapEnum.MAP_4_6: 3,
	MapEnum.MAP_5_1: 2,
	MapEnum.MAP_5_2: 2,
	MapEnum.MAP_5_3: 2,
	MapEnum.MAP_5_4: 2,
	MapEnum.MAP_5_5: 2,
	MapEnum.MAP_5_6: 2
}

export (MapEnum) var map = MapEnum.START_GAME
export (MapEnum) var last_map = MapEnum.MAP_4_6
export (MapEnum) var saved_map = MapEnum.NO_SAVE
export var first_song = 10
export var can_wait = false

var current_gamestate = GameState.CONTROL_CUTSCENE
var next_gamestate = GameState.CONTROL_NULL

var current_map_resource = null
var current_map = null
var current_map_id = -1
var normal_play = true
var game_started = false

func _ready():
	$PauseController.control_id = GameState.CONTROL_PAUSE
	$PlayerController.control_id = GameState.CONTROL_PLAYER
	$CutsceneController.control_id = GameState.CONTROL_CUTSCENE

	$CutsceneController.connect("proceed", self, "continue_game")
	$CutsceneController.connect("start_new_game", self, "start_new_game")
	$MusicManager.change_song(10)
	
	if saved_map == MapEnum.NO_SAVE:
		load_game()
	
	if saved_map == MapEnum.OVERRIDE_SAVE:
		save_game(MapEnum.NO_SAVE)
		load_game()
	
	if map != MapEnum.START_GAME:
		$UIContainer.set_transparent()
		$UIContainer.set_phase_game()
		current_map_id = map
		load_new_level()
		start_new_level()
		normal_play = false
		current_gamestate = GameState.CONTROL_PLAYER
	else:
		current_map_id = MapEnum.MAP_1_1
		$UIContainer.fade_in_start_screen()

func get_has_act_toggle():
	return not can_wait

func start_new_game():
	if not game_started:
		save_game(MapEnum.MAP_1_1)
		game_started = true
	
	$UIContainer.proceed()

func continue_game():
	if game_started:
		$UIContainer.proceed()
	else:
		game_started = true
		if saved_map == MapEnum.NO_SAVE:
			start_new_game()
		else:
			current_map_id = saved_map
			$UIContainer.set_phase_game()
			$UIContainer.fade_continue()
			current_gamestate = GameState.CONTROL_PLAYER

func save_game(map_id):
	var save_file = File.new()
	save_file.open("user://savegame.save", File.WRITE)
	save_file.store_line(String(map_id))
	save_file.close()

func load_game():
	var save_file = File.new()
	
	if not save_file.file_exists("user://savegame.save"):
		save_game(MapEnum.NO_SAVE)
		
	save_file.open("user://savegame.save", File.READ)
	saved_map = int(save_file.get_as_text())
	save_file.close()

func reset_map():
	$UIContainer.fade_out_death()

func load_new_map():
	$UIContainer.fade_straight_to_next_map()

func start_first_song():
	$MusicManager.change_song(map_music[current_map_id])

func go_to_next_map():
	$UIContainer.fade_out_level_title()
	$MusicManager.change_active_character(0)
	$AudioEffectManager.play_sound("level_transition")
	$MusicManager.change_song(map_music[current_map_id + 1])

	if current_map_id == last_map:
		next_gamestate = GameState.CONTROL_CUTSCENE
		load_map_text(current_map.map_end_text)
		$UIContainer.set_final()
		$MusicManager.change_song(11)
		
	elif normal_play:
		current_map_id += 1
		if current_map.map_end_text == "":
			load_new_map()
		else:
			load_map_text(current_map.map_end_text)
	else:
		get_tree().quit()

func load_map_text(map_text):
	next_gamestate = GameState.CONTROL_CUTSCENE
	$UIContainer.fade_map_text(map_text)

func get_gamestate():
	return current_gamestate
	
func get_map_id():
	return current_map_id

func from_player_to_pause():
	next_gamestate = GameState.CONTROL_PAUSE
	current_map.set_pause(true)
	$UIContainer.fade_in_pause_screen()
	
func from_pause_to_player():
	next_gamestate = GameState.CONTROL_PLAYER
	current_map.set_pause(false)
	$UIContainer.fade_out_pause_screen()

func get_map_from_list(map_id):
	return final_map_dict[map_id]

func load_new_level(reset = false):
	if current_map != null:
		current_map.queue_free()
	
	if not reset:
		current_map_resource = load(get_map_from_list(current_map_id))

	current_map = current_map_resource.instance()
	add_child(current_map)
	
	var character_tmp = current_map.get_player_character()
	character_tmp.connect("map_exit", self, "go_to_next_map")
	$UIContainer.set_level_name(current_map.level_title)
	$PlayerController.set_player_character(character_tmp)
	$UIContainer.connect_character_to_ui(character_tmp)
	$CanvasModulate.color = current_map.map_overlay_color
	current_map.set_pause(true)
	current_map.start_map()
	save_game(current_map_id)

func start_new_level():
	next_gamestate = GameState.CONTROL_PLAYER
	current_map.set_pause(false)
	$MusicManager.change_song(map_music[current_map_id])
	$UIContainer.fade_in_level_title()

func play_sound(sound_string):
	$AudioEffectManager.play_sound(sound_string)

func change_active_character(new_character):
	$MusicManager.change_active_character(new_character)

func _process(_delta):
	if next_gamestate != GameState.CONTROL_NULL:
		current_gamestate = next_gamestate
		next_gamestate = GameState.CONTROL_NULL
