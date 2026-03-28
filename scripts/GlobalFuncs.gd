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


func write_to_json_file(file_path: String, file_contents: Dictionary):
	var file = FileAccess.open(file_path, FileAccess.WRITE_READ)
	file.store_line(JSON.stringify(file_contents, "\t"))
	file.close()


func avoid_notch(root: Control):
	var safe = DisplayServer.get_display_safe_area()
	root.position.y += safe.position.y


func avoid_notch_bottom(root: Control):
	var safe = DisplayServer.get_display_safe_area()

	root.size.y -= safe.position.y * 2

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
