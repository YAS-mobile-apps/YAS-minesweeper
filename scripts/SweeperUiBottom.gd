extends PanelContainer

class_name SweeperUiBottom 

@onready var menu_button = %MenuButton
@onready var hold_timer_menu = %HoldTimerMenu


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
