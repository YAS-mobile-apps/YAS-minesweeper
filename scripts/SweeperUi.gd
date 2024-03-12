extends CanvasLayer

class_name SweeperUI 

@export var mine_grid: MineSweeperTileMap

@onready var mine_count_label = %MineCountLabel
@onready var game_status_button = %GameStatusButton
@onready var timer_count_label = %TimerCountLabel
@onready var save_score_window = %"Save Score window"
@onready var list_score_window = %"List Score window"

const TEXT_PADDING_SIZE: int = 3

var game_lost_button_texture = preload("res://assets/tiles/button_lose.png")
var game_won_button_texture = preload("res://assets/tiles/button_win.png")
var default_button_texture = preload("res://assets/tiles/button_smile.png")


func _ready():
	game_status_button.pressed.connect(_game_status_button_pressed)


func _game_status_button_pressed():
	get_tree().reload_current_scene()


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


func game_won(time_elapsed):
	game_status_button.texture_normal = game_won_button_texture
	save_score_window.visible = true


func max_flag_warning(reset: bool = false):
	var color: String = GlobalVariables.COUNTERS_FONT_COLOUR if reset else "white"
	mine_count_label.add_theme_color_override("font_color",color)


func reset_smile_button():
	game_status_button.texture_normal = default_button_texture
