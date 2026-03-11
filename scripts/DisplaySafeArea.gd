extends PanelContainer

@onready var baseNode = %BaseNode
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalFuncs.avoid_notch(self)
	GlobalFuncs.avoid_notch_bottom(self)

	var styleBox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", baseNode.theme.get_meta("top_ui_background_color"))
	add_theme_stylebox_override("panel", styleBox)
