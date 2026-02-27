extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalFuncs.avoid_notch_bottom(self)

