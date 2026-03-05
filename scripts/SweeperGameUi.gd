extends VBoxContainer

@onready var baseNode = %BaseNode

# Called when the node enters the scene tree for the first time.
func _ready():
	add_theme_constant_override("separation", baseNode.theme.get_meta("sweeper_game_ui_separation"))

