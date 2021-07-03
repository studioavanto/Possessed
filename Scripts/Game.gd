extends Node2D

enum GameState { CONTROL_PLAYER, CONTROL_PAUSE, CONTROL_NULL }
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
	MapEnum.MAP_1_1: "res://Scenes/Maps/PlaceholderMap.tscn",
	MapEnum.MAP_1_2: "res://Scenes/Maps/PlaceholderMap.tscn",
	MapEnum.MAP_1_3: "res://Scenes/Maps/PlaceholderMap.tscn",
	MapEnum.MAP_1_4: "res://Scenes/Maps/PlaceholderMap.tscn"
}

enum NamedEnum {THING_1, THING_2, ANOTHER_THING = -1}
export (MapEnum) var map = MapEnum.START_GAME

var current_gamestate = GameState.CONTROL_PLAYER
var next_gamestate = GameState.CONTROL_NULL

var current_map = null

func _ready():
	$PauseController.control_id = GameState.CONTROL_PAUSE
	$PlayerController.control_id = GameState.CONTROL_PLAYER
	
	if map != MapEnum.START_GAME:
		load_new_map(map)

func load_new_map(new_map):
	if current_map != null:
		# ADD SOME DELOADING STUFF HERE
		pass
	
	var current_map = load(map_dict[new_map]).instance()
	add_child(current_map)
	$PlayerController.set_player_character(current_map.get_player_character())

func get_gamestate():
	return current_gamestate

func from_player_to_pause():
	next_gamestate = GameState.CONTROL_PAUSE

func from_pause_to_player():
	next_gamestate = GameState.CONTROL_PLAYER

func _process(_delta):
	if next_gamestate != GameState.CONTROL_NULL:
		current_gamestate = next_gamestate
		next_gamestate = GameState.CONTROL_NULL
