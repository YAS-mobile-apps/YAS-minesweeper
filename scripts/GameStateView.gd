extends Node

class_name GameStateView

@onready var tileMap = %TileMap
@onready var sweeperUiTop = %SweeperUiTop
@onready var sweeperUiBottom = %SweeperUiBottom
@onready var timer = $Timer
@onready var scoreTable = %ScoreTable

var time_elapsed = 0
var opened_menu = false
var timer_menu = false


func _ready():
	opened_menu = sweeperUiBottom.menuButton.get_popup()
	opened_menu.connect("id_pressed", swap_dificulty)
	timer_menu = sweeperUiBottom.holdTimerMenu.get_popup()
	timer_menu.connect("id_pressed", swap_hold_timer)
	
	load_settings()
	load_score_table()
	
	sweeperUiTop.swap_flag_placement_type(false)
	sweeperUiBottom.update_dificulty(GlobalVars.settings.dificulty, opened_menu)
	sweeperUiBottom.update_hold_timer(GlobalVars.settings.hold_click, timer_menu)
	
	tileMap.game_lost.connect(on_game_lost)
	tileMap.flag_placed.connect(on_flag_placed)
	tileMap.game_win.connect(on_game_won)
	tileMap.game_start.connect(on_game_start)
	tileMap.max_flags_placed.connect(on_max_flags_placed)
	sweeperUiTop.set_mine_count(
		tileMap.MINE_AMOUNT[GlobalVars.settings.dificulty]
	)
	sweeperUiTop.flip_flag_placement.connect(flip_flag_placement)
	tileMap.new_game()


func flip_flag_placement():
	if GlobalVars.settings.click_reverse:
		GlobalVars.settings.click_reverse = false
	else:
		GlobalVars.settings.click_reverse = true
	write_file_settings()


func swap_dificulty(pressed_id: int):
	GlobalVars.settings.dificulty = GlobalVars.PRESSED_ID[pressed_id]
	sweeperUiBottom.update_dificulty(GlobalVars.settings.dificulty, opened_menu)
	write_file_settings()
	tileMap.new_game()


func swap_hold_timer(pressed_id: int):
	GlobalVars.settings.hold_click = GlobalVars.HOLD_TIMER_ID[pressed_id]
	sweeperUiBottom.update_hold_timer(GlobalVars.settings.hold_click, timer_menu)
	write_file_settings()


func _on_timer_timeout():
	if tileMap.first_move:
		time_elapsed = time_elapsed + 1
	sweeperUiTop.set_timer_count(time_elapsed)
	sweeperUiTop.max_flag_warning(true)


func on_game_lost():
	timer.stop()
	sweeperUiTop.game_lost()


func on_game_won():
	timer.stop()
	var total_score = tileMap.board_3bv_score / max(time_elapsed, 1)
	var current_score = max(total_score, tileMap.board_3bv_score)
	sweeperUiTop.game_won(time_elapsed, current_score)


func on_game_start():
	time_elapsed = 0
	load_settings()
	load_score_table()
	sweeperUiTop.set_timer_count(time_elapsed)
	sweeperUiTop.set_mine_count(
		tileMap.MINE_AMOUNT[GlobalVars.settings.dificulty]
	)
	sweeperUiTop.reset_smile_button()
	sweeperUiBottom.update_dificulty(GlobalVars.settings.dificulty, opened_menu)
	sweeperUiBottom.update_hold_timer(GlobalVars.settings.hold_click, timer_menu)


func on_flag_placed(flag_count: int):
	sweeperUiTop.set_mine_count(
		tileMap.MINE_AMOUNT[GlobalVars.settings.dificulty] - flag_count
	)


func on_max_flags_placed():
	sweeperUiTop.max_flag_warning()



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
	sweeperUiBottom.update_dificulty(GlobalVars.settings.dificulty, opened_menu)
	sweeperUiBottom.update_hold_timer(GlobalVars.settings.hold_click, timer_menu)


func write_file_settings():
	GlobalFuncs.write_to_json_file(
		GlobalVars.SETTINGS_FILE_PATH, GlobalVars.settings
	)


func reset_file_settings():
	GlobalFuncs.write_to_json_file(
		GlobalVars.SETTINGS_FILE_PATH, GlobalVars.settings
	)
