extends Node

class_name GameStateView

@export var mine_grid: MineSweeperTileMap
@export var sweeper_ui: SweeperUI

@onready var timer = $Timer

var time_elapsed = 0


func _ready():
	mine_grid.game_lost.connect(on_game_lost)
	mine_grid.flag_placed.connect(on_flag_placed)
	mine_grid.game_win.connect(on_game_won)
	mine_grid.game_start.connect(on_game_start)
	mine_grid.max_flags_placed.connect(on_max_flags_placed)
	sweeper_ui.set_mine_count(mine_grid.existing_mines)
	load_score_table()

func _on_timer_timeout():
	if mine_grid.first_move:
		time_elapsed = time_elapsed + 1
	sweeper_ui.set_timer_count(time_elapsed)
	sweeper_ui.max_flag_warning(true)


func on_game_lost():
	timer.stop()
	sweeper_ui.game_lost()


func on_game_won():
	timer.stop()
	var total_score = mine_grid.board_3bv_score / max(time_elapsed, 1)
	var current_score = max(total_score, mine_grid.board_3bv_score)
	sweeper_ui.game_won(time_elapsed, current_score)


func on_game_start():
	time_elapsed = 0
	load_score_table()
	sweeper_ui.set_timer_count(time_elapsed)
	sweeper_ui.set_mine_count(mine_grid.existing_mines)
	sweeper_ui.reset_smile_button()


func on_flag_placed(flag_count: int):
	sweeper_ui.set_mine_count(mine_grid.existing_mines - flag_count)


func on_max_flags_placed():
	sweeper_ui.max_flag_warning()


func load_score_table():
	if !FileAccess.file_exists(GlobalVariables.SCORE_TABLE_FILE_PATH):
		reset_file_score_table()

	var score_file = FileAccess.open(GlobalVariables.SCORE_TABLE_FILE_PATH, FileAccess.READ)
	var json_object = JSON.new()
	var parse_err = json_object.parse(score_file.get_as_text())
	score_file.close()
	if parse_err != OK:
		print('b')
		reset_file_score_table()

	GlobalVariables.current_scores = json_object.data


func reset_file_score_table():
	var file = FileAccess.open(GlobalVariables.SCORE_TABLE_FILE_PATH, FileAccess.WRITE_READ)
	file.store_line(JSON.stringify(GlobalVariables.current_scores, "\t"))
	file.close()
