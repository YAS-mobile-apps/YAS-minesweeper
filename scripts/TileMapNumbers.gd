extends Node2D

class_name TileMapNumbers

const TILE_SIZE = Vector2i(49, 48)

@onready var baseNode = %BaseNode
@onready var theme: Theme = %BaseNode.theme

var color_codes: Dictionary = {}
var cells_mine_count: Dictionary = {}
var font: Font = null
var font_size: int = 12
var text_vertical_offset = null

func _ready():
	font = theme.get_font("font", "Label")
	font_size = theme.get_meta("label_font_size")
	color_codes = theme.get_meta("NumberColors")
	text_vertical_offset = TILE_SIZE.y / 2.0 + font_size / 2.0


func _draw():
	for coord in cells_mine_count:
		var tile_position = Vector2(coord) * Vector2(TILE_SIZE)
		var text = str(cells_mine_count[coord])
		var text_position = tile_position + Vector2(0, text_vertical_offset)

		draw_string(
			font,
			text_position,
			text,
			HORIZONTAL_ALIGNMENT_CENTER,
			TILE_SIZE.x,
			font_size,
			color_codes[cells_mine_count[coord]]
		)


func clear_numbers():
	cells_mine_count.clear()
	queue_redraw()

