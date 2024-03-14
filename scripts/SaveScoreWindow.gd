extends Window

class_name SaveScoreWindow

@export var sweeper_ui: SweeperUI


func _ready():
	sweeper_ui.save_score.connect(save_score)


func save_score(current_player_name, final_score, final_time):
	var file = FileAccess.open(GlobalVariables.SCORE_TABLE_FILE_PATH, FileAccess.WRITE_READ)
	var score_line: Dictionary = {"Name": current_player_name, "Score": final_score, "time": final_time, "datetime": Time.get_datetime_string_from_system()}
	
	GlobalVariables.current_scores["normal_mode"].scores.append(score_line)
	file.store_line(JSON.stringify(GlobalVariables.current_scores, "\t"))
	file.close()
	
	get_tree().reload_current_scene()
