extends PanelContainer

class_name SweeperUiBottom 

@onready var menu_button = %MenuButton
@onready var hold_timer_menu = %HoldTimerMenu
@onready var current_theme = %BaseNode.theme

# Called when the node enters the scene tree for the first time.
func _ready():
	var styleBox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", current_theme.get_meta("bottom_ui_background_color"))
	add_theme_stylebox_override("panel", styleBox)

func update_dificulty(dificulty: String, opened_menu: PopupMenu):
	menu_button.text = "DIFICULTY: " + dificulty.to_upper().split("_")[0]
	for id in range(opened_menu.item_count):
		opened_menu.set_item_disabled(id, false)
	opened_menu.set_item_disabled(GlobalVars.DIFICULTY_ID[dificulty], true)
	

func update_hold_timer(hold_time_label: String, opened_menu: PopupMenu):
	hold_timer_menu.text = hold_time_label.to_upper() + ": HOLD TIMER"
	for id in range(opened_menu.item_count):
		opened_menu.set_item_disabled(id, false)
	opened_menu.set_item_disabled(GlobalVars.HOLD_TIMER_LABELS[hold_time_label], true)
