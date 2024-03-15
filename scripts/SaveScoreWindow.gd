extends Window

class_name SaveScoreWindow

@export var sweeper_ui: SweeperUI


func _ready():
	sweeper_ui.save_score.connect(save_score)


func save_score(current_player_name, final_score, final_time):
	var file = FileAccess.open(GlobalVars.SCORE_TABLE_FILE_PATH, FileAccess.WRITE_READ)
	var score_line: Dictionary = {
		"Name": current_player_name, 
		"Score": final_score, 
		"time": final_time, 
		"datetime": Time.get_datetime_string_from_system()
	}
	
	GlobalVars.current_scores[
		GlobalVars.settings.dificulty
	].scores.append(score_line)
	
	if GlobalVars.current_scores[
		GlobalVars.settings.dificulty
	].highest_score > final_score:
		GlobalVars.current_scores[
			GlobalVars.settings.dificulty
		].highest_score = final_score

	GlobalVars.current_scores[
		GlobalVars.settings.dificulty
	].last_player_name = current_player_name

	file.store_line(JSON.stringify(GlobalVars.current_scores, "\t"))
	file.close()
	
	get_tree().reload_current_scene()
