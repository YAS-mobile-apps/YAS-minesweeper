extends PanelContainer

@onready var menuReturnToHome: Button = %MenuReturnToHome
@onready var scoresButton: Button = %ScoresButton
@onready var scoresIcon: Button = %ScoresIcon
@onready var themesButton: Button = %ThemesButton
@onready var themesIcon: Button = %ThemesIcon
@onready var highScoreTable = %HighScoresTable
@onready var highScoreCanvas = %HighScoreCanvas
@onready var themeMenuUiContainer = %ThemeMenuUiContainer

func _ready():
	ThemeManager.theme_changed.connect(on_theme_changed)
	on_theme_changed()

	menuReturnToHome.pressed.connect(on_return_button_pressed)

	scoresButton.pressed.connect(on_score_button_pressed)
	scoresIcon.pressed.connect(on_score_button_pressed)

	themesButton.pressed.connect(on_themes_button_pressed)
	themesIcon.pressed.connect(on_themes_button_pressed)


func on_return_button_pressed():
	self.visible = false


func on_theme_changed(_theme_name: String = ""):
	ThemeManager.apply(self, ThemeManager.get_current_theme_name())


func on_score_button_pressed():
	self.visible = false
	highScoreTable.fill_score_table(GlobalVars.settings.dificulty)
	highScoreCanvas.visible = true

func on_themes_button_pressed():
	self.visible = false
	themeMenuUiContainer.visible = true
