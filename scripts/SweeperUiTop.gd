extends PanelContainer

class_name SweeperUiTop 

@export var mine_grid: MineSweeperTileMap

@onready var mine_count_label = %MineCountLabel
@onready var game_status_button = %GameStatusButton
@onready var timer_count_label = %TimerCountLabel
@onready var save_score_window = %SaveScoreWindow
@onready var list_score_window = %ListScoreWindow
@onready var score_button = %ScoreButton
@onready var current_user_name_field = %CurrentUserTextEdit
@onready var current_score_label = %ScoreTextLabel
@onready var current_time_score_label = %TimeTextLabel
@onready var save_cancel_button = %SaveCancelButton
@onready var save_confirm_button = %SaveConfirmButton
@onready var score_table = %ScoreTable
@onready var flag_placement_set_button = %FlagPlacementSetButton
@onready var current_theme: Theme = %BaseNode.theme
@onready var highscore_canvas = %HighScoreCanvas
@onready var highscore_table = %HighScoresTable
@onready var sweeper_game_ui = %SweeperGameUi

const TEXT_PADDING_SIZE: int = 3

var game_lost_button_texture = null
var game_won_button_texture = null
var default_button_texture = null

var flag_placement_set_right_texture = null
var flag_placement_set_left_texture = null

var final_score: int = 0
var final_time: int = 0
var current_player_name: String = ""

signal flip_flag_placement


func _ready():
	game_lost_button_texture = current_theme.get_meta("button_lose")
	game_won_button_texture = current_theme.get_meta("button_win")
	default_button_texture = current_theme.get_meta("button_smile")

	flag_placement_set_right_texture = current_theme.get_meta("mine_as_default")
	flag_placement_set_left_texture = current_theme.get_meta("flag_as_default")
	
	game_status_button.pressed.connect(game_reset_button_pressed)
	save_cancel_button.pressed.connect(game_reset_button_pressed)
	save_confirm_button.pressed.connect(save_confirm_button_pressed)
	flag_placement_set_button.pressed.connect(swap_flag_placement_type)
	score_button.pressed.connect(score_button_pressed)

	var styleBox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", current_theme.get_meta("top_ui_background_color"))
	add_theme_stylebox_override("panel", styleBox)
	
	GlobalFuncs.avoid_notch(self)


func game_reset_button_pressed():
	save_score_window.visible = false
	clear_save_score_fields()


func save_confirm_button_pressed():
	current_player_name = current_user_name_field.text
	save_score_window.save_score(current_player_name, final_score, final_time)
	clear_save_score_fields()


func swap_flag_placement_type(emit_flip_signal: bool = true):
	if emit_flip_signal:
		flip_flag_placement.emit()
	if GlobalVars.settings.click_reverse:
		flag_placement_set_button.texture_normal = flag_placement_set_left_texture
	else:
		flag_placement_set_button.texture_normal = flag_placement_set_right_texture


func score_button_pressed():
	highscore_table.fill_score_table(GlobalVars.settings.dificulty)
	highscore_canvas.visible = true
	sweeper_game_ui.visible = false
	sweeper_game_ui.process_mode = PROCESS_MODE_DISABLED

func set_mine_count(mine_count: int):
	var font_color = current_theme.get_meta("mine_counter_font_color")
	mine_count_label.add_theme_color_override("font_color", font_color)

	var font_size = current_theme.get_meta("mine_counter_font_size")
	mine_count_label.add_theme_font_size_override("font_size", font_size)

	var mine_count_string = str(mine_count)
	if len(mine_count_string) < TEXT_PADDING_SIZE:
		mine_count_string = mine_count_string.lpad(TEXT_PADDING_SIZE, "0")
	mine_count_label.text = mine_count_string


func set_timer_count(timer_count: int):
	var font_color = current_theme.get_meta("timer_font_color")
	timer_count_label.add_theme_color_override("font_color", font_color)

	var font_size = current_theme.get_meta("timer_font_size")
	mine_count_label.add_theme_font_size_override("font_size", font_size)

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
	
	current_score_label.add_text(str(final_score))
	current_time_score_label.add_text(str(time_elapsed))
	
	if GlobalVars.current_scores[GlobalVars.settings.dificulty].last_player_name:
		current_user_name_field.insert_text_at_caret(
			GlobalVars.current_scores[GlobalVars.settings.dificulty].last_player_name
		)
	save_score_window.visible = true


func max_flag_warning(_reset: bool = false):
	var color = current_theme.get_meta("mine_counter_font_color")
	mine_count_label.add_theme_color_override("font_color", color)


func reset_smile_button():
	game_status_button.texture_normal = default_button_texture


func clear_save_score_fields():
	current_score_label.clear()
	current_time_score_label.clear()
	current_user_name_field.clear()

	current_score_label.add_text("Your Score: ")
	current_time_score_label.add_text("Your Time: ")
