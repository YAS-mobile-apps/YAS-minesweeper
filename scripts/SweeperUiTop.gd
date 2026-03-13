extends PanelContainer

class_name SweeperUiTop 

const TEXT_PADDING_SIZE: int = 3


@onready var mineCountLabel = %MineCountLabel
@onready var gameStatusButton = %GameStatusButton
@onready var timerCountLabel = %TimerCountLabel
@onready var saveScoreWindow = %SaveScoreWindow
@onready var scoreButton = %ScoreButton
@onready var currentUserTextEdit = %CurrentUserTextEdit
@onready var scoreTextLabel = %ScoreTextLabel
@onready var timeTextLabel = %TimeTextLabel
@onready var saveCancelButton = %SaveCancelButton
@onready var saveConfirmButton = %SaveConfirmButton
@onready var flagPlacementSetButton = %FlagPlacementSetButton
@onready var baseNode = %BaseNode
@onready var highScoreCanvas = %HighScoreCanvas
@onready var highScoreTable = %HighScoresTable
@onready var sweeperGameUi = %SweeperGameUi
@onready var tileMap = %TileMap
@onready var tileMapNumbers = %TileMapNumbers
@onready var gameStateView = %GameStateView

signal toggle_score_window(visibility: bool)
signal save_score(final_score: int, final_time: int)
signal reset_game

var game_lost_button_texture = null
var game_won_button_texture = null
var default_button_texture = null

var flag_placement_set_right_texture = null
var flag_placement_set_left_texture = null

var final_score: int = 0
var final_time: int = 0


func _ready():
	game_lost_button_texture = baseNode.get_tile_texture(GlobalVars.CELLS.lose)
	game_won_button_texture = baseNode.get_tile_texture(GlobalVars.CELLS.win)
	default_button_texture = baseNode.get_tile_texture(GlobalVars.CELLS.smile)

	flag_placement_set_right_texture = baseNode.get_tile_texture(GlobalVars.CELLS.mine)
	flag_placement_set_left_texture = baseNode.get_tile_texture(GlobalVars.CELLS.flag)

	gameStatusButton.texture_normal = baseNode.get_tile_texture(GlobalVars.CELLS.smile)
	gameStatusButton.texture_pressed = baseNode.get_tile_texture(GlobalVars.CELLS.smile_click)

	scoreButton.texture_normal = baseNode.get_tile_texture(GlobalVars.CELLS.winners)
	scoreButton.texture_pressed = baseNode.get_tile_texture(GlobalVars.CELLS.winners)
	scoreButton.texture_hover = baseNode.get_tile_texture(GlobalVars.CELLS.winners_click)

	gameStatusButton.pressed.connect(game_status_button_pressed)
	saveCancelButton.pressed.connect(game_reset_button_pressed)
	saveConfirmButton.pressed.connect(save_confirm_button_pressed)
	flagPlacementSetButton.pressed.connect(swap_flag_placement_type)
	scoreButton.pressed.connect(score_button_pressed)

	var styleBox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", baseNode.theme.get_meta("top_ui_background_color"))
	add_theme_stylebox_override("panel", styleBox)

	tileMap.game_lost.connect(on_game_lost)
	tileMap.flag_placed.connect(on_flag_placed)
	tileMap.game_start.connect(on_game_start)
	tileMap.max_flags_placed.connect(on_max_flags_placed)

	gameStateView.timer_timeout.connect(on_timer_timeout)

	swap_flag_placement_type(true)
	set_mine_count(GlobalVars.MINE_AMOUNT[GlobalVars.settings.dificulty])


func on_flag_placed(flag_count):
	set_mine_count(GlobalVars.MINE_AMOUNT[GlobalVars.settings.dificulty] - flag_count)


func on_game_start():
	set_timer_count(0)
	set_mine_count(GlobalVars.MINE_AMOUNT[GlobalVars.settings.dificulty])
	reset_smile_button()


func on_max_flags_placed():
	max_flag_warning()


func on_timer_timeout(time_elapsed: int):
	set_timer_count(time_elapsed)
	max_flag_warning(true)


func game_reset_button_pressed():
	toggle_score_window.emit(false)
	clear_save_score_fields()


func game_status_button_pressed():
	toggle_score_window.emit(false)
	clear_save_score_fields()
	reset_game.emit()


func save_confirm_button_pressed():
	save_score.emit(final_score, final_time)
	clear_save_score_fields()


func swap_flag_placement_type(read_only: bool = false):
	if GlobalVars.settings.click_reverse:
		flagPlacementSetButton.texture_normal = flag_placement_set_left_texture
		if !read_only: GlobalVars.settings.click_reverse = false
	else:
		flagPlacementSetButton.texture_normal = flag_placement_set_right_texture
		if !read_only: GlobalVars.settings.click_reverse = true

	if !read_only: GlobalFuncs.write_to_json_file(
		GlobalVars.SETTINGS_FILE_PATH, GlobalVars.settings
	)


func score_button_pressed():
	highScoreTable.fill_score_table(GlobalVars.settings.dificulty)
	highScoreCanvas.visible = true
	sweeperGameUi.visible = false
	tileMapNumbers.visible = false
	sweeperGameUi.process_mode = PROCESS_MODE_DISABLED


func set_mine_count(mine_count: int):
	var font_color = baseNode.theme.get_meta("mine_counter_font_color")
	mineCountLabel.add_theme_color_override("font_color", font_color)

	var font_size = baseNode.theme.get_meta("mine_counter_font_size")
	mineCountLabel.add_theme_font_size_override("font_size", font_size)

	var mine_count_string = str(mine_count)
	if len(mine_count_string) < TEXT_PADDING_SIZE:
		mine_count_string = mine_count_string.lpad(TEXT_PADDING_SIZE, "0")
	mineCountLabel.text = mine_count_string


func set_timer_count(timer_count: int):
	var font_color = baseNode.theme.get_meta("timer_font_color")
	timerCountLabel.add_theme_color_override("font_color", font_color)

	var font_size = baseNode.theme.get_meta("timer_font_size")
	mineCountLabel.add_theme_font_size_override("font_size", font_size)

	var time_string = str(timer_count)
	if len(time_string) < 3:
		time_string = time_string.lpad(3, "0")
	timerCountLabel.text = time_string


func on_game_lost():
	gameStatusButton.texture_normal = game_lost_button_texture


func game_won(time_elapsed, current_score):
	final_time = time_elapsed
	final_score = current_score
	gameStatusButton.texture_normal = game_won_button_texture
	
	scoreTextLabel.add_text(str(final_score))
	timeTextLabel.add_text(str(time_elapsed))


func max_flag_warning(_reset: bool = false):
	var color = baseNode.theme.get_meta("mine_counter_font_color")
	mineCountLabel.add_theme_color_override("font_color", color)


func reset_smile_button():
	gameStatusButton.texture_normal = default_button_texture


func clear_save_score_fields():
	scoreTextLabel.clear()
	timeTextLabel.clear()

	scoreTextLabel.add_text("Your Score: ")
	timeTextLabel.add_text("Your Time: ")
