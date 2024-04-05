extends CanvasLayer

class_name SweeperUIBottom 

@onready var menu_button = %MenuButton
@onready var hold_timer_menu = %HoldTimerMenu

const PRESSED_ID: Dictionary = {
	0:"normal_mode",
	1:"medium_mode",
	2:"hard_mode"
}

const DIFICULTY_ID: Dictionary = {
	"normal_mode":0,
	"medium_mode":1,
	"hard_mode":2,
	"dev_mode":0
}

const HOLD_TIMER_ID: Dictionary = {
	0:"short",
	1:"medium",
	2:"long"
}

const HOLD_TIMER_LABELS: Dictionary = {
	"short":0,
	"medium":1,
	"long":2,
}


func update_dificulty(dificulty: String, opened_menu: PopupMenu):
	menu_button.text = "Dificulty: " + dificulty
	for id in range(opened_menu.item_count):
		opened_menu.set_item_disabled(id, false)
	opened_menu.set_item_disabled(DIFICULTY_ID[dificulty], true)
	

func update_hold_timer(hold_time_label: String, opened_menu: PopupMenu):
	hold_timer_menu.text = hold_time_label + ": Hold timer"
	for id in range(opened_menu.item_count):
		opened_menu.set_item_disabled(id, false)
	opened_menu.set_item_disabled(HOLD_TIMER_LABELS[hold_time_label], true)
