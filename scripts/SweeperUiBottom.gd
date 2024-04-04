extends CanvasLayer

class_name SweeperUIBottom 

@onready var menu_button = %MenuButton

const PRESSED_ID: Dictionary = {
	0:"normal_mode",
	1:"medium_mode",
	2:"hard_mode"
}

const DIFICULTY_ID: Dictionary = {
	"normal_mode":0,
	"medium_mode":1,
	"hard_mode":2
}

func update_dificulty(dificulty: String, opened_menu: PopupMenu):
	menu_button.text = "Dificulty: " + dificulty
	opened_menu.set_item_disabled(DIFICULTY_ID[dificulty], true)
