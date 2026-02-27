extends VBoxContainer
@onready var current_theme: Theme = %BaseNode.theme

# Called when the node enters the scene tree for the first time.
func _ready():
	add_theme_constant_override("separation", current_theme.get_meta("sweeper_game_ui_separation"))

