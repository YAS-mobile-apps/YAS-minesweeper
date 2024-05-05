extends Node

class_name GameStateView

@export var mine_grid: MineSweeperTileMap
@export var sweeper_ui_top: SweeperUI
@export var sweeper_ui_bottom: SweeperUIBottom

@onready var timer = $Timer

var time_elapsed = 0
var opened_menu = false
var timer_menu = false

func _ready():
	opened_menu = sweeper_ui_bottom.menu_button.get_popup()
	opened_menu.connect("id_pressed", swap_dificulty)
	timer_menu = sweeper_ui_bottom.hold_timer_menu.get_popup()
	timer_menu.connect("id_pressed", swap_hold_timer)
	
	load_score_table()
	load_settings()
	
	sweeper_ui_top.swap_flag_placement_type(false)
	sweeper_ui_bottom.update_dificulty(GlobalVars.settings.dificulty, opened_menu)
	sweeper_ui_bottom.update_hold_timer(GlobalVars.settings.hold_click, timer_menu)
	
	mine_grid.game_lost.connect(on_game_lost)
	mine_grid.flag_placed.connect(on_flag_placed)
	mine_grid.game_win.connect(on_game_won)
	mine_grid.game_start.connect(on_game_start)
	mine_grid.max_flags_placed.connect(on_max_flags_placed)
	sweeper_ui_top.set_mine_count(
		mine_grid.MINE_AMOUNT[GlobalVars.settings.dificulty]
	)
	sweeper_ui_top.flip_flag_placement.connect(flip_flag_placement)
	mine_grid.new_game()


func flip_flag_placement():
	if GlobalVars.settings.click_reverse:
		GlobalVars.settings.click_reverse = false
	else:
		GlobalVars.settings.click_reverse = true
	write_file_settings()


func swap_dificulty(pressed_id: int):
	GlobalVars.settings.dificulty = GlobalVars.PRESSED_ID[pressed_id]
	sweeper_ui_bottom.update_dificulty(GlobalVars.settings.dificulty, opened_menu)
	write_file_settings()
	get_tree().reload_current_scene()


func swap_hold_timer(pressed_id: int):
	GlobalVars.settings.hold_click = GlobalVars.HOLD_TIMER_ID[pressed_id]
	sweeper_ui_bottom.update_hold_timer(GlobalVars.settings.hold_click, timer_menu)
	write_file_settings()


func _on_timer_timeout():
	if mine_grid.first_move:
		time_elapsed = time_elapsed + 1
	sweeper_ui_top.set_timer_count(time_elapsed)
	sweeper_ui_top.max_flag_warning(true)


func on_game_lost():
	timer.stop()
	sweeper_ui_top.game_lost()


func on_game_won():
	timer.stop()
	var total_score = mine_grid.board_3bv_score / max(time_elapsed, 1)
	var current_score = max(total_score, mine_grid.board_3bv_score)
	sweeper_ui_top.game_won(time_elapsed, current_score)


func on_game_start():
	time_elapsed = 0
	load_score_table()
	load_settings()
	sweeper_ui_top.set_timer_count(time_elapsed)
	sweeper_ui_top.set_mine_count(
		mine_grid.MINE_AMOUNT[GlobalVars.settings.dificulty]
	)
	sweeper_ui_top.reset_smile_button()
	sweeper_ui_bottom.update_dificulty(GlobalVars.settings.dificulty, opened_menu)
	sweeper_ui_bottom.update_hold_timer(GlobalVars.settings.hold_click, timer_menu)


func on_flag_placed(flag_count: int):
	sweeper_ui_top.set_mine_count(
		mine_grid.MINE_AMOUNT[GlobalVars.settings.dificulty] - flag_count
	)


func on_max_flags_placed():
	sweeper_ui_top.max_flag_warning()


func load_score_table():
	var file_scores = GlobalFuncs.load_from_json_file(
		GlobalVars.SCORE_TABLE_FILE_PATH
	)
	if not file_scores:
		reset_file_score_table()
		return
	GlobalVars.current_scores = file_scores
	for score_line in GlobalVars.current_scores[
		GlobalVars.settings.dificulty
	].scores:
		sweeper_ui_top.score_table.add_item(str(score_line))


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
	sweeper_ui_bottom.update_dificulty(GlobalVars.settings.dificulty, opened_menu)
	sweeper_ui_bottom.update_hold_timer(GlobalVars.settings.hold_click, timer_menu)

func write_file_settings():
	GlobalFuncs.write_to_json_file(
		GlobalVars.SETTINGS_FILE_PATH, GlobalVars.settings
	)


func reset_file_settings():
	GlobalFuncs.write_to_json_file(
		GlobalVars.SETTINGS_FILE_PATH, GlobalVars.settings
	)
