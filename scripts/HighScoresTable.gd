extends Control
class_name Table

@onready var m_NodeTableRows : Control = get_node("ScoreScreen/TableMargins/TableContents/TableRows")
@onready var return_to_home = %ReturnToHome
@onready var table_contents = $ScoreScreen/TableMargins/ScrollContainer/TableContents
@onready var scroll_container = %ScrollContainer


func _ready():
	fill_score_table(GlobalVars.settings.dificulty)
	return_to_home.pressed.connect(go_back)


func go_back():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func fill_score_table(dificulty: String):
	for score_row in GlobalVars.current_scores[dificulty].scores:
		new_score_row(
			score_row.Name, 
			str(score_row.Score), 
			str(score_row.time), 
			score_row.datetime
		)


func new_score_row(player_name : String, score : String, time: String, datetime: String) -> void:
	#var new_table_row : TableRow = preload("res://scenes/high_score_table/table_row.tscn").instantiate() as TableRow
	#table_contents.add_child(new_table_row)
	#new_table_row.set_row(player_name, score, time, datetime)
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
	value_date.text = datetime
	var separator5 = VSeparator.new()

	table_contents.add_child(separator1)
	table_contents.add_child(value_name)
	table_contents.add_child(separator2)
	table_contents.add_child(value_score)
	table_contents.add_child(separator3)
	table_contents.add_child(value_time)
	table_contents.add_child(separator4)
	table_contents.add_child(value_date)
	table_contents.add_child(separator5)
