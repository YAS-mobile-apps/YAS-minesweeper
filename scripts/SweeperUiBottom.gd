extends PanelContainer

class_name SweeperUiBottom 

@onready var menuButton = %MenuButton
@onready var holdTimerMenu = %HoldTimerMenu
@onready var baseNode = %BaseNode
@onready var gameStateView = %GameStateView
@onready var tileMap = %TileMap

@onready var opened_menu = menuButton.get_popup()
@onready var timer_menu = holdTimerMenu.get_popup()


func _ready():
	var styleBox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", baseNode.theme.get_meta("bottom_ui_background_color"))
	add_theme_stylebox_override("panel", styleBox)
	GlobalFuncs.avoid_notch_bottom(self)

	opened_menu.connect("id_pressed", update_dificulty)
	timer_menu.connect("id_pressed", update_hold_timer)

	tileMap.game_start.connect(on_game_start)


func on_game_start():
	update_settings(true)


func update_settings(read_only: bool = false):
	update_dificulty(GlobalVars.DIFICULTY_ID[GlobalVars.settings.dificulty], read_only)
	update_hold_timer(GlobalVars.HOLD_TIMER_LABELS[GlobalVars.settings.hold_click], read_only)


func update_dificulty(pressed_id: int, read_only: bool = false):
	if !read_only: GlobalVars.settings.dificulty = GlobalVars.PRESSED_ID[pressed_id]
	var dificulty = GlobalVars.settings.dificulty

	menuButton.text = "DIFICULTY: " + dificulty.to_upper().split("_")[0]
	for id in range(opened_menu.item_count):
		opened_menu.set_item_disabled(id, false)
	opened_menu.set_item_disabled(GlobalVars.DIFICULTY_ID[dificulty], true)

	if !read_only: GlobalFuncs.write_to_json_file(
		GlobalVars.SETTINGS_FILE_PATH, GlobalVars.settings
	)
	if !read_only: tileMap.new_game()


func update_hold_timer(pressed_id: int, read_only: bool = false):
	if !read_only: GlobalVars.settings.hold_click = GlobalVars.HOLD_TIMER_ID[pressed_id]
	var hold_time_label = GlobalVars.settings.hold_click

	holdTimerMenu.text = hold_time_label.to_upper() + ": HOLD TIMER"
	for id in range(timer_menu.item_count):
		timer_menu.set_item_disabled(id, false)
	timer_menu.set_item_disabled(GlobalVars.HOLD_TIMER_LABELS[hold_time_label], true)

	if !read_only: GlobalFuncs.write_to_json_file(
		GlobalVars.SETTINGS_FILE_PATH, GlobalVars.settings
	)
