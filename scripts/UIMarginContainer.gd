class_name UIMarginContainer
extends MarginContainer

@onready var current_theme = %BaseNode.theme

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalFuncs.avoid_notch(self)
