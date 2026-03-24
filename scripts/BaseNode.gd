extends PanelContainer

class_name BaseNode


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	ThemeManager.theme_changed.connect(on_theme_changed)
	on_theme_changed()

func on_theme_changed(_theme_name: String = ""):
	ThemeManager.apply(self, ThemeManager.get_current_theme_name())
