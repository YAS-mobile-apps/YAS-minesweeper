extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalFuncs.avoid_notch(self)
	GlobalFuncs.avoid_notch_bottom(self)
	GlobalFuncs.set_background_color(self, ThemeManager.current_theme, "background_color")
