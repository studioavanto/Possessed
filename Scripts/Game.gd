extends Node2D

enum GameState { CONTROL_PLAYER, CONTROL_PAUSE, CONTROL_NULL, CONTROL_CUTSCENE }
enum MapEnum { 
	START_GAME,
	TEST_ILMO, TEST_VILLE, TEST_JOONAS, TEST_JOHANNES, 
	MAP_1_1, MAP_1_2, MAP_1_3, MAP_1_4
	}

var map_dict = {
	MapEnum.TEST_ILMO: "res://Scenes/Maps/TestMaps/TestIlmo.tscn",
	MapEnum.TEST_VILLE: "res://Scenes/Maps/TestMaps/TestVille.tscn",
	MapEnum.TEST_JOHANNES: "res://Scenes/Maps/TestMaps/TestJohannes.tscn",
	MapEnum.TEST_JOONAS: "res://Scenes/Maps/TestMaps/TestJoonas.tscn",
	MapEnum.MAP_1_1: "res://Scenes/Maps/Map1_1.tscn",
	MapEnum.MAP_1_2: "res://Scenes/Maps/Map1_2.tscn",
	MapEnum.MAP_1_3: "res://Scenes/Maps/PlaceholderMap.tscn",
	MapEnum.MAP_1_4: "res://Scenes/Maps/PlaceholderMap.tscn"
}

enum NamedEnum {THING_1, THING_2, ANOTHER_THING = -1}
export (MapEnum) var map = MapEnum.START_GAME

var current_gamestate = GameState.CONTROL_PLAYER
var next_gamestate = GameState.CONTROL_NULL

var current_map = null
var current_map_id = -1

func _ready():
	$PauseController.control_id = GameState.CONTROL_PAUSE
	$PlayerController.control_id = GameState.CONTROL_PLAYER
	$CutsceneController.control_id = GameState.CONTROL_CUTSCENE
	
	if map != MapEnum.START_GAME:
		load_new_map(map)
	
	$CutsceneController.connect("proceed", $UIContainer,"proceed")

func load_new_map(new_map):
	next_gamestate = GameState.CONTROL_CUTSCENE
	$UIContainer.show_new_map(new_map)
	current_map_id = new_map

func go_to_next_map():
	get_tree().quit()

func get_gamestate():
	return current_gamestate

func from_player_to_pause():
	next_gamestate = GameState.CONTROL_PAUSE

func from_pause_to_player():
	next_gamestate = GameState.CONTROL_PLAYER
	
func load_new_level():
	# TODO REMOVE OLD MAP
	
	current_map = load(map_dict[current_map_id]).instance()
	add_child(current_map)
	var character_tmp = current_map.get_player_character()
	character_tmp.connect("map_exit", self, "go_to_next_map")
	$PlayerController.set_player_character(character_tmp)
	$UIContainer.connect_character_to_ui(character_tmp)
	current_map.set_pause(true)
	
func start_new_level():
	current_map.set_pause(false)
	next_gamestate = GameState.CONTROL_PLAYER

func _process(_delta):
	if next_gamestate != GameState.CONTROL_NULL:
		current_gamestate = next_gamestate
		next_gamestate = GameState.CONTROL_NULL
