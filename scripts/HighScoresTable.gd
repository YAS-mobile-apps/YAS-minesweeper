extends Control
class_name Table

@onready var m_NodeTableRows : VBoxContainer = get_node("ScoreScreen/TableMargins/TableContents/TableRows")
@onready var return_to_home = %ReturnToHome


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
	var new_table_row : TableRow = preload("res://scenes/high_score_table/table_row.tscn").instantiate() as TableRow
	m_NodeTableRows.add_child(new_table_row)
	new_table_row.set_row(player_name, score, time, datetime)
