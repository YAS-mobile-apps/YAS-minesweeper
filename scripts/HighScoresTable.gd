extends Control
class_name Table

@onready var returnToHome = %ReturnToHome
@onready var scoreTableContents = %ScoreTableContents
@onready var scoreDificiltyMenu = %HighScoresLabel
@onready var headerName = %ScoreTableContents/Name
@onready var headerScore = %ScoreTableContents/Score
@onready var headerTime = %ScoreTableContents/Time
@onready var headerCreatedAt = %ScoreTableContents/CreatedAt
@onready var highScoreCanvas = %HighScoreCanvas
@onready var sweeperGameUi = %SweeperGameUi
@onready var tileMapNumbers = %TileMapNumbers

var current_sort_table: String = 'none'
var score_table_dificulty: String = GlobalVars.settings.dificulty
var opened_menu = null

func _ready():
	opened_menu = scoreDificiltyMenu.get_popup()
	opened_menu.connect("id_pressed", swap_dificulty)
	
	score_table_dificulty = GlobalVars.settings.dificulty
	fill_score_table(score_table_dificulty)
	returnToHome.pressed.connect(go_back)
	scoreDificiltyMenu.text = "High Scores: " + score_table_dificulty
	headerName.pressed.connect(sort_by_name)
	headerScore.pressed.connect(sort_by_score)
	headerTime.pressed.connect(sort_by_time)
	headerCreatedAt.pressed.connect(sort_by_created)

func swap_dificulty(pressed_id: int):
	score_table_dificulty = GlobalVars.PRESSED_ID[pressed_id]
	fill_score_table(score_table_dificulty)


func format_datetime_string(datetime_string: String) -> String:
	var dt = Time.get_datetime_dict_from_datetime_string(datetime_string, false)
	var dt_year = str(dt.year)
	var half_year = dt_year[-2] + dt_year[-1]
	return "%02d/%02d/%s %02d:%02d" % [
		dt.day,
		dt.month,
		half_year,
		dt.hour,
		dt.minute
	]


func go_back():
	highScoreCanvas.visible = false
	sweeperGameUi.visible = true
	tileMapNumbers.visible = true
	sweeperGameUi.process_mode = PROCESS_MODE_INHERIT


func sort_by_name():
	fill_score_table(score_table_dificulty, "Name")


func sort_by_score():
	fill_score_table(score_table_dificulty, "Score")


func sort_by_time():
	fill_score_table(score_table_dificulty, "time")


func sort_by_created():
	fill_score_table(score_table_dificulty, "datetime")


func fill_score_table(dificulty: String, sort_key: String = ""):
	score_table_dificulty_menu(dificulty, opened_menu)
	var scores: Array = GlobalVars.current_scores[dificulty].scores
	if sort_key and sort_key == current_sort_table:
		return
	
	for child in scoreTableContents.get_children():
		if child.is_in_group('score_line'):
			scoreTableContents.remove_child(child)
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
	scoreDificiltyMenu.text = "High Scores: " + dificulty
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

	scoreTableContents.add_child(separator1)
	scoreTableContents.add_child(value_name)
	scoreTableContents.add_child(separator2)
	scoreTableContents.add_child(value_score)
	scoreTableContents.add_child(separator3)
	scoreTableContents.add_child(value_time)
	scoreTableContents.add_child(separator4)
	scoreTableContents.add_child(value_date)
	scoreTableContents.add_child(separator5)
