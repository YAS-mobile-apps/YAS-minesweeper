extends PanelContainer

@onready var themeSelectorLine = %ThemeSelectorLine
@onready var themeSelectorVBoxContainer = %ThemeSelectorVBoxContainer
@onready var themeMenuReturnToHome = %ThemeMenuReturnToHome

@onready var numbers_unlocked: Dictionary = GlobalVars.settings.achievements.numbers_found

func _ready():
	GlobalFuncs.avoid_notch(self)
	ThemeManager.theme_changed.connect(on_theme_changed)
	on_theme_changed()
	draw_theme_selection()
	themeMenuReturnToHome.pressed.connect(go_back)

func go_back():
	self.visible = false

func on_theme_changed(_theme_name: String = ""):
	ThemeManager.apply(self, ThemeManager.get_current_theme_name())

func draw_theme_selection():
	var number_requirement: int = 1
	var number_amount_to_find: int = 8

	for game_theme in ThemeManager.themes.keys():
		var new_theme_line = themeSelectorLine.duplicate()
		
		var panel = new_theme_line.get_node("ThemeSelectorLineContainer")
		var theme_name = new_theme_line.get_node("ThemeSelectorLineContainer/ThemeLineGridContainer/HBoxContainerLine2/ThemeLineNameLabel")
		var apply_button = new_theme_line.get_node("ThemeSelectorLineContainer/ThemeLineGridContainer/HBoxContainerLine2/MarginContainer/ThemeLineApplyButton")
		var theme_requirements = new_theme_line.get_node("ThemeSelectorLineContainer/ThemeLineGridContainer/HBoxContainerLine1/ThemeLineRequirementsLabel")
		
		var base_tileset = StyleBoxTexture.new()
		base_tileset.texture = ThemeManager.themes[game_theme].get_meta("base_tiles")
		panel.add_theme_stylebox_override("panel", base_tileset)
		base_tileset.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
		base_tileset.axis_stretch_vertical = (StyleBoxTexture.AXIS_STRETCH_MODE_TILE_FIT)

		theme_name.text = game_theme
		new_theme_line.visible = true
		apply_button.pressed.connect(save_and_apply_theme.bind(game_theme))
		themeSelectorVBoxContainer.add_child(new_theme_line)
		theme_requirements.text = ""
		
		if game_theme not in ["default", "development"]:
			var unlocked_numbers = numbers_unlocked[str(number_requirement)]
			var is_enabled = unlocked_numbers >= number_amount_to_find
			theme_requirements.text = "Find '" + str(unlocked_numbers) + "/" + str(number_amount_to_find) + "' number" + " '" + str(number_requirement) + "'"
			number_requirement += 1
			number_amount_to_find -= 1
			apply_button.disabled = !is_enabled


func save_and_apply_theme(game_theme: String):
	ThemeManager.change_global_theme(game_theme)
	GlobalVars.settings.current_theme = game_theme

	GlobalFuncs.write_to_json_file(
		GlobalVars.SETTINGS_FILE_PATH, GlobalVars.settings
	)

