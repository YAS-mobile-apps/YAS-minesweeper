extends Node


func load_from_json_file(filepath: String):
	if !FileAccess.file_exists(filepath):
		return false
	var file = FileAccess.open(filepath, FileAccess.READ)
	var json_object = JSON.new()
	var parse_err = json_object.parse(file.get_as_text())
	file.close()
	if parse_err != OK:
		return false
		
	return json_object.data

func numbers_found_tracking(number_found: int):
	GlobalVars.settings.achievements.numbers_found[str(number_found)] += 1
	GlobalFuncs.write_to_json_file(
		GlobalVars.SETTINGS_FILE_PATH, GlobalVars.settings
	)

func write_to_json_file(file_path: String, file_contents: Dictionary):
	var file = FileAccess.open(file_path, FileAccess.WRITE_READ)
	file.store_line(JSON.stringify(file_contents, "\t"))
	file.close()


func avoid_notch(root: Control):
	var safe_area = DisplayServer.get_display_safe_area()
	var top_safe = safe_area.position.y
	root.add_theme_constant_override("margin_top", top_safe)


func avoid_notch_bottom(root: Control):
	var safe_area = DisplayServer.get_display_safe_area()
	var screen = DisplayServer.screen_get_size()	
	var bottom_safe = screen.y - (safe_area.position.y + safe_area.size.y)
	root.add_theme_constant_override("margin_bottom", bottom_safe)

func quick_sort(arr, key_to_sort):
	if arr.size() <= 1:
		return arr

	var pivot = arr[arr.size() / 2][key_to_sort]
	var less = []
	var equal = []
	var greater = []

	for item in arr:
		var value = item[key_to_sort]
		if value < pivot:
			less.append(item)
		elif value == pivot:
			equal.append(item)
		else:
			greater.append(item)

	return quick_sort(less, key_to_sort) + equal + quick_sort(greater, key_to_sort)


func set_background_color(root: Control, theme: Theme, background_type: String):
	var styleBox: StyleBoxFlat = root.get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", theme.get_meta(background_type))
	root.add_theme_stylebox_override("panel", styleBox)
