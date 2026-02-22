extends PanelContainer
@onready var current_theme = %BaseNode.theme

# Called when the node enters the scene tree for the first time.
func _ready():
	var styleBox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", current_theme.get_meta("top_ui_background_color"))
	add_theme_stylebox_override("panel", styleBox)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
