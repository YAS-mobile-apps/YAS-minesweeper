extends Node

class_name GameStateView

@export var sweeper_ui_top_path: NodePath
@export var score_table_path: NodePath
@export var tile_map_path: NodePath

@onready var tileMap = get_node(tile_map_path)
@onready var sweeperUiTop = get_node(sweeper_ui_top_path)
@onready var timer = $Timer    
@onready var scoreTable = get_node(score_table_path)

signal timer_timeout(time_elapsed)
signal settings_loaded

var time_elapsed: int = 0
var opened_menu: bool = false
var timer_menu: bool = false


func _ready():	
	load_settings()
	load_score_table()
		
	tileMap.game_lost.connect(on_game_lost)
	tileMap.game_win.connect(on_game_won)
	tileMap.game_start.connect(on_game_start)
	tileMap.new_game()


func _on_timer_timeout():
	if tileMap.first_move:
		time_elapsed = time_elapsed + 1
	timer_timeout.emit(time_elapsed)


func on_game_lost():
	timer.stop()


func on_game_won():
	timer.stop()
	sweeperUiTop.game_won(time_elapsed, tileMap.board_3bv_score)


func on_game_start():
	time_elapsed = 0
	load_settings()
	load_score_table()


func load_score_table():
	var file_scores = GlobalFuncs.load_from_json_file(
		GlobalVars.SCORE_TABLE_FILE_PATH
	)
	if not file_scores:
		reset_file_score_table()
		return
	GlobalVars.current_scores = file_scores
	for score_line in GlobalVars.current_scores[GlobalVars.settings.dificulty].scores:
		scoreTable.add_item(str(score_line))


func reset_file_score_table():
	GlobalFuncs.write_to_json_file(
		GlobalVars.SCORE_TABLE_FILE_PATH, GlobalVars.current_scores
	)


func load_settings():
	var settings = GlobalFuncs.load_from_json_file(
		GlobalVars.SETTINGS_FILE_PATH
	)
	if not settings:
		reset_file_settings()
		return
	for key in GlobalVars.settings:
		if key not in settings:
			reset_file_settings()
			return
	
	GlobalVars.settings = settings
	
	ThemeManager.change_global_theme(GlobalVars.settings.current_theme)

	settings_loaded.emit()


func reset_file_settings():
	GlobalFuncs.write_to_json_file(
		GlobalVars.SETTINGS_FILE_PATH, GlobalVars.settings
	)
