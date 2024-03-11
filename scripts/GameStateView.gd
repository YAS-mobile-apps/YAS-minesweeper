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


func _on_timer_timeout():
	if mine_grid.first_move:
		time_elapsed = time_elapsed + 1
	sweeper_ui.set_timer_count(time_elapsed)
	sweeper_ui.max_flag_warning(true)


func on_game_lost():
	sweeper_ui.game_lost()
	timer.stop()


func on_game_won():
	sweeper_ui.game_won()
	timer.stop()


func on_game_start():
	time_elapsed = 0
	sweeper_ui.set_timer_count(time_elapsed)
	sweeper_ui.set_mine_count(mine_grid.existing_mines)
	sweeper_ui.reset_smile_button()


func on_flag_placed(flag_count: int):
	sweeper_ui.set_mine_count(mine_grid.existing_mines - flag_count)


func on_max_flags_placed():
	sweeper_ui.max_flag_warning()
	

