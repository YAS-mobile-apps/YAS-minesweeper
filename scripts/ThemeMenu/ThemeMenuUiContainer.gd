extends PanelContainer

@onready var themeSelectorLine = %ThemeSelectorLine
@onready var themeSelectorVBoxContainer = %ThemeSelectorVBoxContainer
@onready var themeMenuReturnToHome = %ThemeMenuReturnToHome
@onready var gameStateView = %GameStateView

var panel_path: NodePath = "ThemeSelectorLineContainer"
var theme_name_path: NodePath = "ThemeSelectorLineContainer/ThemeLineGridContainer/HBoxContainerLine2/ThemeLineNameLabel"
var apply_button_path: NodePath = "ThemeSelectorLineContainer/ThemeLineGridContainer/HBoxContainerLine2/MarginContainer/ThemeLineApplyButton"
var theme_requirements_path: NodePath = "ThemeSelectorLineContainer/ThemeLineGridContainer/HBoxContainerLine1/ThemeLineRequirementsLabel"

var numbers_unlocked: Dictionary = GlobalVars.settings.achievements.numbers_found


func _ready():
	GlobalFuncs.avoid_notch(self)
	ThemeManager.theme_changed.connect(on_theme_changed)
	
	on_theme_changed()
	themeMenuReturnToHome.pressed.connect(go_back)
	gameStateView.settings_loaded.connect(on_settings_loaded)


func go_back():
	self.visible = false


func on_theme_changed(_theme_name: String = ""):
	ThemeManager.apply(self, ThemeManager.get_current_theme_name())


func on_settings_loaded():
	numbers_unlocked = GlobalVars.settings.achievements.numbers_found
	draw_theme_selection(true)


func draw_theme_selection(redraw: bool = false):
	if redraw: erase_previous_selection()
	
	var number_requirement: int = 1
	var number_amount_to_find: int = 8
	numbers_unlocked = GlobalVars.settings.achievements.numbers_found

	for game_theme in ThemeManager.themes.keys():
		var new_theme_line = themeSelectorLine.duplicate()
		
		var panel = new_theme_line.get_node(panel_path)
		var theme_name = new_theme_line.get_node(theme_name_path)
		var apply_button = new_theme_line.get_node(apply_button_path)
		var theme_requirements = new_theme_line.get_node(theme_requirements_path)
		
		var base_tileset = StyleBoxTexture.new()
		base_tileset.texture = ThemeManager.themes[game_theme].get_meta("base_tiles")
		panel.add_theme_stylebox_override("panel", base_tileset)
		base_tileset.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
		base_tileset.axis_stretch_vertical = (StyleBoxTexture.AXIS_STRETCH_MODE_TILE_FIT)
		
		theme_requirements.add_theme_color_override("font_shadow_color", Color.BLACK)
		theme_requirements.add_theme_constant_override("shadow_offset_x", 1)
		theme_requirements.add_theme_constant_override("shadow_offset_y", 1)
		
		theme_name.add_theme_color_override("font_shadow_color", Color.BLACK)
		theme_name.add_theme_constant_override("shadow_offset_x", 1)
		theme_name.add_theme_constant_override("shadow_offset_y", 1)
		
		theme_name.text = game_theme
		new_theme_line.visible = true
		apply_button.pressed.connect(save_and_apply_theme.bind(game_theme))
		themeSelectorVBoxContainer.add_child(new_theme_line)
		theme_requirements.text = ""
		
		if game_theme not in ["default", "development"]:
			var unlocked_numbers: int = numbers_unlocked[str(number_requirement)]
			var is_enabled: bool = unlocked_numbers >= number_amount_to_find
			var display_unlocked_numbers: int = min(unlocked_numbers, number_amount_to_find)
			theme_requirements.text = "Find '" + str(display_unlocked_numbers) + "/" + str(number_amount_to_find) + "' number" + " '" + str(number_requirement) + "'"
			number_requirement += 1
			number_amount_to_find -= 1
			apply_button.disabled = !is_enabled
			if !is_enabled:
				panel.modulate.a = 0.5

func save_and_apply_theme(game_theme: String):
	ThemeManager.change_global_theme(game_theme)
	GlobalVars.settings.current_theme = game_theme

	GlobalFuncs.write_to_json_file(
		GlobalVars.SETTINGS_FILE_PATH, GlobalVars.settings
	)


func erase_previous_selection():
	for child in themeSelectorVBoxContainer.get_children():
		if child != themeSelectorLine:
			child.call_deferred("queue_free")
