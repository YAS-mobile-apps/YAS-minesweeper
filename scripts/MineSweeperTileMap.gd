extends TileMap

class_name MineSweeperTileMap

const TILE_SET_ID = 0
const DEFAULT_LAYER = 0
const SURROUNDING_POSITIONS: Array = [
	Vector2i.UP, 
	Vector2i.DOWN, 
	Vector2i.LEFT, 
	Vector2i.RIGHT, 
	Vector2i.UP + Vector2i.LEFT, 
	Vector2i.UP + Vector2i.RIGHT, 
	Vector2i.DOWN + Vector2i.LEFT, 
	Vector2i.DOWN + Vector2i.RIGHT
] 
const CELLS: Dictionary = {
	"0": Vector2i(12, 0),
	"1": Vector2i(0,0),
	"2": Vector2i(1,0),
	"3": Vector2i(2,0),
	"4": Vector2i(3,0),
	"5": Vector2i(4,0),
	"6": Vector2i(5,0),
	"7": Vector2i(6,0),
	"8": Vector2i(7,0),
	"mine": Vector2i(8,0),
	"flag": Vector2i(9,0),
	"default": Vector2i(10,0),
	"mine_hit": Vector2i(11,0),
}
const MINE_AMOUNT: Dictionary = {
	"dev_mode": 1,
	"normal_mode": 9,
	"medium_mode": 12,
	"hard_mode": 19,
}
const MOUSE_HOLD_TIMES: Dictionary = {
	"short": 0.200,
	"medium": 0.350,
	"long": 0.450,
}
@export var columns = 8
@export var rows = 8
@export var game_state_view: GameStateView

signal game_start
signal game_lost
signal game_win
signal flag_placed
signal max_flags_placed

var existing_cells: Array[Vector2i] = []
var cells_with_mine: Array[Vector2i] = []
var cells_checked: Array[Vector2i] = []
var is_game_finished: bool = false
var first_move: bool = false
var placed_flags: int = 0
var cells_open: int = 0
var board_3bv_score: int = 0
var is_mouse_hold: bool = false
var mouse_held_timer: float = 0


func get_tile_range() -> Array[int]:
	var row_start = - int(rows / 2.0)
	var row_end = int(rows / 2.0) - 1
	var column_start = - int(columns / 2.0)
	var column_end = int(columns / 2.0) - 1
	return [row_start, row_end, column_start, column_end]


func _physics_process(delta):
	if is_mouse_hold:
		mouse_held_timer = mouse_held_timer + delta


func new_game():
	game_start.emit()
	clear_layer(DEFAULT_LAYER)
	cells_with_mine = []
	existing_cells = []
	cells_checked = []
	is_game_finished = false
	placed_flags = 0
	cells_open = 0
	first_move = false
	
	for row in rows:
		for column in columns:
			var cell_coord = Vector2i(row - int(rows / 2.0), column - int(columns / 2.0))
			set_tile_cell(cell_coord, CELLS.default)
			existing_cells.append(cell_coord)
	
	place_mines()


func _input(event: InputEvent):
	var is_mouse_event: bool = event is InputEventMouseButton
	var is_touch_event: bool = event is InputEventScreenTouch
	var is_press: bool = event.is_pressed()
	var is_release: bool = event.is_released()
	
	if !is_mouse_event and !is_touch_event:
		return
		
	if is_press:
		is_mouse_hold = true
		mouse_held_timer = 0
	if is_release:
		is_mouse_hold = false

	var selected_position: Vector2
	var selected_cell_coord: Vector2i
	var held_long_enough: bool = mouse_held_timer > MOUSE_HOLD_TIMES[
		GlobalVars.settings.hold_click
		]

	selected_position = get_local_mouse_position()
	selected_cell_coord = local_to_map(selected_position)
	
	var release_left_button: bool = event.button_index == MOUSE_BUTTON_LEFT \
		and is_release
	var release_right_button: bool = event.button_index == MOUSE_BUTTON_RIGHT \
		and is_release

	var mine_button = release_right_button if GlobalVars.settings.click_reverse \
		else release_left_button
	var flag_button = release_right_button if !GlobalVars.settings.click_reverse \
		else release_left_button
	
	if mine_button:
		if held_long_enough:
			flag_placement(selected_cell_coord)
		else:
			if is_game_finished:
				new_game()
			on_cell_selection(selected_cell_coord)
	elif flag_button:
		if held_long_enough and GlobalVars.settings.click_reverse:
			if is_game_finished:
				new_game()
			on_cell_selection(selected_cell_coord)
		else:
			flag_placement(selected_cell_coord)
	

func place_mines():
	match get_tile_range():
		[var row_start, var row_end, var column_start, var column_end]:
			for i in MINE_AMOUNT[GlobalVars.settings.dificulty]:
				var mine_coords = Vector2i(
					randi_range(row_start, row_end), 
					randi_range(column_start, column_end)
				)
				while cells_with_mine.has(mine_coords):
					mine_coords = Vector2i(
						randi_range(row_start, row_end),
						randi_range(column_start, column_end)
					)
				cells_with_mine.append(mine_coords)
			board_3bv_score = get_board_3bv_score()
	
	for cell in cells_with_mine:
		erase_cell(DEFAULT_LAYER, cell)
		set_tile_cell(cell, CELLS.default, 1)


func get_board_3bv_score() -> int:		
	var marked_cells: Array[Vector2i] = []
	var mine_count: int = 0
	var value_3bv: int = 0
		
	for cell_coord in existing_cells:
		mine_count = int(check_surrounding_mines(cell_coord))
		if mine_count == 0 and !cells_with_mine.has(cell_coord):
			if !marked_cells.has(cell_coord):
				value_3bv = value_3bv + 1
				marked_cells.append(cell_coord)
				marked_cells = _calculate_3bv_neighbor_cells(
					cell_coord, marked_cells, value_3bv
				)[0]
				value_3bv = _calculate_3bv_neighbor_cells(
					cell_coord, marked_cells, value_3bv
				)[1]
		elif mine_count > 0 \
		and !marked_cells.has(cell_coord) \
		and !cells_with_mine.has(cell_coord):
			value_3bv = value_3bv + 1
	return value_3bv


func _calculate_3bv_neighbor_cells(cell_coord: Vector2i, marked_cells: Array[Vector2i], value_3bv: int):
	var neighboor_coord: Vector2i
	
	for cell_direction in SURROUNDING_POSITIONS: 
		neighboor_coord = cell_coord + cell_direction
		if !existing_cells.has(neighboor_coord):
			continue
		if !marked_cells.has(neighboor_coord):
			marked_cells.append(neighboor_coord)
			if check_surrounding_mines(neighboor_coord) == "0":
				_calculate_3bv_neighbor_cells(
					neighboor_coord, marked_cells, value_3bv
				)
	return [marked_cells, value_3bv]


func set_tile_cell(cell_coord: Vector2i,  cell_type: Vector2i, alternative_tile: int = 0):
	set_cell(
		DEFAULT_LAYER, cell_coord, TILE_SET_ID, cell_type, alternative_tile
	)


func flag_placement(cell_coord: Vector2i):
	var tile_data = get_cell_tile_data(DEFAULT_LAYER, cell_coord)
	if not tile_data:
		return
	var atlas_coord = get_cell_atlas_coords(DEFAULT_LAYER, cell_coord)
	
	if atlas_coord == CELLS.default:
		if placed_flags == MINE_AMOUNT[GlobalVars.settings.dificulty]:
			max_flags_placed.emit()
			return
			
		set_tile_cell(cell_coord, CELLS.flag)
		placed_flags = placed_flags + 1
		flag_placed.emit(placed_flags)
	elif atlas_coord == CELLS.flag and cells_with_mine.has(cell_coord):
		set_tile_cell(cell_coord, CELLS.default, 1)
		placed_flags = placed_flags - 1
		flag_placed.emit(placed_flags)
	elif atlas_coord == CELLS.flag:
		set_tile_cell(cell_coord, CELLS.default)
		placed_flags = placed_flags - 1
		flag_placed.emit(placed_flags)
	if placed_flags < 0:
		placed_flags = 0
		flag_placed.emit(placed_flags)


func on_cell_selection(cell_coord: Vector2i):
	if cells_with_mine.has(cell_coord):
		game_over(cell_coord)
		return
	if cells_checked.has(cell_coord):
		return
	cells_checked.append(cell_coord)
	handle_cell(cell_coord)


func handle_cell(cell_coord: Vector2i):
	var tile_data = get_cell_tile_data(DEFAULT_LAYER, cell_coord)
	if tile_data == null:
		return

	if not first_move:
		first_move = true
		game_state_view.timer.start()

	var atlas_coord = get_cell_atlas_coords(DEFAULT_LAYER, cell_coord)
	if atlas_coord == CELLS.flag:
		placed_flags = placed_flags - 1
		flag_placed.emit(placed_flags)
	if placed_flags < 0:
		placed_flags = 0
		flag_placed.emit(placed_flags)
	
	var mine_count = check_surrounding_mines(cell_coord)
	set_tile_cell(cell_coord, CELLS[mine_count])
	cells_open = cells_open + 1
	cells_checked.append(cell_coord)
	
	if mine_count != "0": 
		check_for_win_condition()
		return
		
	for cell_direction in SURROUNDING_POSITIONS:
		handle_surrounding_cell(cell_coord + cell_direction)


func handle_surrounding_cell(cell_coord: Vector2i):
	var tile_data = get_cell_tile_data(DEFAULT_LAYER,cell_coord)
	if tile_data == null or cells_checked.has(cell_coord):
		check_for_win_condition()
		return
	handle_cell(cell_coord)


func check_surrounding_mines(cell_coord: Vector2i):
	var mine_count = 0
	for cell_direction in SURROUNDING_POSITIONS:
		if cells_with_mine.has(cell_coord + cell_direction):
			mine_count = mine_count + 1
	return str(mine_count)


func check_for_win_condition():
	var all_cells_were_checked = false
	if cells_open + MINE_AMOUNT[
		GlobalVars.settings.dificulty
	] == columns * rows:
		all_cells_were_checked = true
	if all_cells_were_checked and not is_game_finished:
		game_won()


func game_won():
	game_win.emit()
	is_game_finished = true
	for cell in cells_with_mine:
		set_tile_cell(cell, CELLS.flag)


func game_over(cell_coord: Vector2i):
	game_lost.emit()
	is_game_finished = true
	for cell in cells_with_mine:
			set_tile_cell(cell, CELLS.mine)
	set_tile_cell(cell_coord, CELLS.mine_hit)

