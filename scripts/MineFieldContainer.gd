extends PanelContainer

@onready var baseNode = %BaseNode

# Called when the node enters the scene tree for the first time.
func _ready():
	var styleBox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", baseNode.theme.get_meta("minefield_background_color"))
	add_theme_stylebox_override("panel", styleBox)

