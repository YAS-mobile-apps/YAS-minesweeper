class_name UIMarginContainer
extends MarginContainer

func _ready() -> void:
	var notch_list: Array[Rect2] = DisplayServer.get_display_cutouts()
	var window_size: Vector2i = DisplayServer.window_get_size_with_decorations()
	var top_margin: int = 0

	if notch_list:
		var notch_area: Rect2 = notch_list[0]
		# here I assume you have only one notch, 
		# if you have more no one can save you
		if notch_area and window_size.y >= notch_area.size.y:
			top_margin = int(notch_area.size.y)
			
	add_theme_constant_override("margin_top", top_margin)
