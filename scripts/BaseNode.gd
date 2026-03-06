extends PanelContainer

class_name BaseNode
# Called when the node enters the scene tree for the first time.
func _ready():
	var styleBox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", self.theme.get_meta("background_color"))
	add_theme_stylebox_override("panel", styleBox)


