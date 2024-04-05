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


func avoid_notch(node):
	var notch_list: Array[Rect2] = DisplayServer.get_display_cutouts()
	var window_size: Vector2i = \
		DisplayServer.window_get_size_with_decorations()
	var top_margin: int = 0

	if notch_list:
		var notch_area: Rect2 = notch_list[0]
		if notch_area and window_size.y >= notch_area.size.y:
			top_margin = int(notch_area.size.y)
			
	node.add_theme_constant_override("margin_top", top_margin)

