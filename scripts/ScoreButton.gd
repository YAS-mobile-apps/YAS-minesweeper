extends Button


func _input(event):
	if !(event is InputEventMouse) or !event.is_pressed():
		return

	if event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://scenes/main.tscn")

