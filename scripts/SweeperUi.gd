extends CanvasLayer

class_name SweeperUI 

@export var mine_grid: MineSweeperTileMap

@onready var mine_count_label = %MineCountLabel
@onready var game_status_button = %GameStatusButton
@onready var timer_count_label = %TimerCountLabel
@onready var save_score_window = %"SaveScoreWindow"
@onready var list_score_window = %"List Score window"
@onready var score_button = %ScoreButton
@onready var current_user_name_field = %CurrentUserTextEdit
@onready var current_score_label = %ScoreTextLabel
@onready var current_time_score_label = %TimeTextLabel
@onready var save_cancel_button = %SaveCancelButton
@onready var save_confirm_button = %SaveConfirmButton
@onready var score_table = %ScoreTable
@onready var flag_placement_set_button = %FlagPlacementSetButton

const TEXT_PADDING_SIZE: int = 3

var game_lost_button_texture = preload("res://assets/tiles/button_lose.png")
var game_won_button_texture = preload("res://assets/tiles/button_win.png")
var default_button_texture = preload("res://assets/tiles/button_smile.png")

var flag_placement_set_right_texture = preload("res://assets/top_ui/mine_as_default.png")
var flag_placement_set_left_texture = preload("res://assets/top_ui/flag_as_default.png")

var final_score: int = 0
var final_time: int = 0
var current_player_name: String = ""

signal save_score
signal flip_flag_placement

func _ready():
	game_status_button.pressed.connect(game_reset_button_pressed)
	save_cancel_button.pressed.connect(game_reset_button_pressed)
	save_confirm_button.pressed.connect(save_confirm_button_pressed)
	flag_placement_set_button.pressed.connect(swap_flag_placement_type)
	score_button.pressed.connect(score_button_pressed)


func game_reset_button_pressed():
	get_tree().reload_current_scene()


func save_confirm_button_pressed():
	current_player_name = current_user_name_field.text
	save_score.emit(current_player_name, final_score, final_time)

func swap_flag_placement_type(emit_flip_signal: bool = true):
	if emit_flip_signal:
		flip_flag_placement.emit()
	if GlobalVars.settings.click_reverse:
		flag_placement_set_button.texture_normal = \
			flag_placement_set_left_texture
	else:
		flag_placement_set_button.texture_normal = \
			flag_placement_set_right_texture

func score_button_pressed():
	get_tree().change_scene_to_file("res://scenes/high_scores.tscn")


func set_mine_count(mine_count: int):
	var mine_count_string = str(mine_count)
	if len(mine_count_string) < TEXT_PADDING_SIZE:
		mine_count_string = mine_count_string.lpad(TEXT_PADDING_SIZE, "0")
	mine_count_label.text = mine_count_string


func set_timer_count(timer_count: int):
	var time_string = str(timer_count)
	if len(time_string) < 3:
		time_string = time_string.lpad(3, "0")
	timer_count_label.text = time_string


func game_lost():
	game_status_button.texture_normal = game_lost_button_texture


func game_won(time_elapsed, current_score):
	final_time = time_elapsed
	final_score = current_score
	game_status_button.texture_normal = game_won_button_texture
	save_score_window.visible = true
	
	current_score_label.add_text(str(final_score))
	current_time_score_label.add_text(str(time_elapsed))
	
	if GlobalVars.current_scores[
		GlobalVars.settings.dificulty
	].last_player_name:
		current_user_name_field.insert_text_at_caret(
			GlobalVars.current_scores[
				GlobalVars.settings.dificulty
				].last_player_name
		)


func max_flag_warning(reset: bool = false):
	var color: String = GlobalVars.COUNTERS_FONT_COLOUR if reset else "white"
	mine_count_label.add_theme_color_override("font_color", color)


func reset_smile_button():
	game_status_button.texture_normal = default_button_texture
