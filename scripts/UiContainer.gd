extends PanelContainer


func _ready():
	ThemeManager.theme_changed.connect(on_theme_changed)
	on_theme_changed()

func on_theme_changed(_theme_name: String = ""):
	ThemeManager.apply(self, ThemeManager.get_current_theme_name())
