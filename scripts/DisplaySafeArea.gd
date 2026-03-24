extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalFuncs.avoid_notch(self)
	GlobalFuncs.set_background_color(self, ThemeManager.get_current_theme(), "background_color")
