extends PanelContainer


func _ready():
	var safe = DisplayServer.get_display_safe_area()
	self.position.y -= safe.position.y

	ThemeManager.theme_changed.connect(on_theme_changed)
	on_theme_changed()

func on_theme_changed(_theme_name: String = ""):
	ThemeManager.apply(self, ThemeManager.get_current_theme_name())
