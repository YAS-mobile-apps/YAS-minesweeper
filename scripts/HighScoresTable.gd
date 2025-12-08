extends Control
class_name Table

@onready var return_to_home = %ReturnToHome
@onready var table_contents = %ScoreTableContents
@onready var scroll_container = %ScrollContainer
@onready var score_dificilty_menu = %HighScoresLabel
@onready var header_name = $ScoreMarginContainer/ScoreScreen/TableMargins/ScrollContainer/ScoreTableContents/Name
@onready var header_score = $ScoreMarginContainer/ScoreScreen/TableMargins/ScrollContainer/ScoreTableContents/Score
@onready var header_time = $ScoreMarginContainer/ScoreScreen/TableMargins/ScrollContainer/ScoreTableContents/Time
@onready var header_created_at = $ScoreMarginContainer/ScoreScreen/TableMargins/ScrollContainer/ScoreTableContents/CreatedAt

var current_sort_table: String = 'none'
var score_table_dificulty: String = GlobalVars.settings.dificulty
var opened_menu = null

func _ready():
	opened_menu = score_dificilty_menu.get_popup()
	opened_menu.connect("id_pressed", swap_dificulty)
	
	score_table_dificulty = GlobalVars.settings.dificulty
	fill_score_table(score_table_dificulty)
	return_to_home.pressed.connect(go_back)
	score_dificilty_menu.text = "High Scores: " + score_table_dificulty
	header_name.pressed.connect(sort_by_name)
	header_score.pressed.connect(sort_by_score)
	header_time.pressed.connect(sort_by_time)
	header_created_at.pressed.connect(sort_by_created)
	score_table_dificulty_menu(score_table_dificulty, opened_menu)

func swap_dificulty(pressed_id: int):
	score_table_dificulty = GlobalVars.PRESSED_ID[pressed_id]
	score_table_dificulty_menu(score_table_dificulty, opened_menu)
	fill_score_table(score_table_dificulty, true)

func format_datetime_string(datetime_string: String) -> String:
	var dt = Time.get_datetime_dict_from_datetime_string(datetime_string, false)
	return "%02d/%02d/%04d %02d:%02d" % [
		dt.day,
		dt.month,
		dt.year,
		dt.hour,
		dt.minute
	]

func go_back():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func sort_by_name():
	fill_score_table(score_table_dificulty, true, "Name")


func sort_by_score():
	fill_score_table(score_table_dificulty, true, "Score")


func sort_by_time():
	fill_score_table(score_table_dificulty, true, "time")


func sort_by_created():
	fill_score_table(score_table_dificulty, true, "datetime")


func fill_score_table(dificulty: String, reload: bool = false, sort_key: String = ""):
	var scores: Array = GlobalVars.current_scores[dificulty].scores
	if sort_key and sort_key == current_sort_table:
		return
	
	if reload:
		for child in table_contents.get_children():
			if child.is_in_group('score_line'):
				table_contents.remove_child(child)
				child.queue_free() 
	
	if sort_key:
		current_sort_table = sort_key
		scores = GlobalFuncs.quick_sort(scores, sort_key)
	
	for score_row in scores:
		new_score_row(
			score_row.Name, 
			str(score_row.Score), 
			str(score_row.time), 
			score_row.datetime
		)


func score_table_dificulty_menu(dificulty: String, current_opened_menu: PopupMenu):
	score_dificilty_menu.text = "High Socres: " + dificulty
	for id in range(current_opened_menu.item_count):
		current_opened_menu.set_item_disabled(id, false)
	current_opened_menu.set_item_disabled(GlobalVars.DIFICULTY_ID[dificulty], true)


func new_score_row(
	player_name : String,
	score : String,
	time: String,
	datetime: String
	) -> void:
	var separator1 = VSeparator.new()
	var value_name = Label.new()
	value_name.text = player_name
	value_name.clip_text = true
	var separator2 = VSeparator.new()
	var value_score = Label.new()
	value_score.text = score
	var separator3 = VSeparator.new()
	var value_time = Label.new()
	value_time.text = time
	var separator4 = VSeparator.new()
	var value_date = Label.new()
	value_date.text = format_datetime_string(datetime)
	var separator5 = VSeparator.new()

	separator1.add_to_group('score_line')
	value_name.add_to_group('score_line')
	separator2.add_to_group('score_line')
	value_score.add_to_group('score_line')
	separator3.add_to_group('score_line')
	value_time.add_to_group('score_line')
	separator4.add_to_group('score_line')
	value_date.add_to_group('score_line')
	separator5.add_to_group('score_line')

	table_contents.add_child(separator1)
	table_contents.add_child(value_name)
	table_contents.add_child(separator2)
	table_contents.add_child(value_score)
	table_contents.add_child(separator3)
	table_contents.add_child(value_time)
	table_contents.add_child(separator4)
	table_contents.add_child(value_date)
	table_contents.add_child(separator5)
