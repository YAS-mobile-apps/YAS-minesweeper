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
