extends Node2D

enum GameState { CONTROL_PLAYER, CONTROL_PAUSE, CONTROL_NULL, CONTROL_CUTSCENE }
enum MapEnum { 
	START_GAME,
	TEST_ILMO, TEST_VILLE, TEST_JOONAS, TEST_JOHANNES, 
	MAP_1_1, MAP_1_2, MAP_1_3, MAP_1_4, MAP_1_5, MAP_1_6, 
	MAP_2_1, MAP_2_2, MAP_2_3, MAP_2_4, MAP_2_5, MAP_2_6, 
	MAP_3_1, MAP_3_2, MAP_3_3, MAP_3_4, MAP_3_5, MAP_3_6, 
	MAP_4_1, MAP_4_2, MAP_4_3, MAP_4_4, MAP_4_5, MAP_4_6, 
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
	MapEnum.MAP_4_6: "res://Scenes/Maps/FinalMaps/Map4_6.tscn"
}

export (MapEnum) var map = MapEnum.START_GAME
export (MapEnum) var last_map = MapEnum.MAP_4_6

var current_gamestate = GameState.CONTROL_CUTSCENE
var next_gamestate = GameState.CONTROL_NULL

var current_map_resource = null
var current_map = null
var current_map_id = -1
var normal_play = true

func _ready():
	$PauseController.control_id = GameState.CONTROL_PAUSE
	$PlayerController.control_id = GameState.CONTROL_PLAYER
	$CutsceneController.control_id = GameState.CONTROL_CUTSCENE

	$CutsceneController.connect("proceed", $UIContainer,"proceed")
	
	if map != MapEnum.START_GAME:
		$UIContainer.set_transparent()
		current_map_id = map
		load_new_level()
		start_new_level()
		normal_play = false
		current_gamestate = GameState.CONTROL_PLAYER
	else:
		current_map_id = MapEnum.MAP_1_1
		$UIContainer.fade_in_start_screen()

func reset_map():
	$UIContainer.fade_out_death()

func load_new_map():
	$UIContainer.fade_straight_to_next_map()

func go_to_next_map():
	$MusicManager.change_active_character(-1)
	if current_map_id == last_map:
		next_gamestate = GameState.CONTROL_CUTSCENE
		$UIContainer.fade_in_end_screen()

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

func from_pause_to_player():
	next_gamestate = GameState.CONTROL_PLAYER

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
	$PlayerController.set_player_character(character_tmp)
	$UIContainer.connect_character_to_ui(character_tmp)
	$CanvasModulate.color = current_map.map_overlay_color
	current_map.set_pause(true)

func start_new_level():
	current_map.set_pause(false)
	next_gamestate = GameState.CONTROL_PLAYER
	$MusicManager.change_song(current_map.map_music_id)

func play_sound(sound_string):
	$AudioEffectManager.play_sound(sound_string)

func change_active_character(new_character):
	$MusicManager.change_active_character(new_character)

func _process(_delta):
	if next_gamestate != GameState.CONTROL_NULL:
		current_gamestate = next_gamestate
		next_gamestate = GameState.CONTROL_NULL
