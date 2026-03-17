extends Window

class_name SaveScoreWindow

@onready var tileMap = %TileMap
@onready var sweeperUiTop = %SweeperUiTop
@onready var currentUserTextEdit = %CurrentUserTextEdit

var current_player_name: String

func _ready():
	tileMap.game_win.connect(on_game_won)
	tileMap.game_start.connect(on_game_start)
	sweeperUiTop.save_score.connect(on_score_saved)
	sweeperUiTop.toggle_score_window.connect(on_toggle_score_window)

func on_score_saved(final_score: int, final_time: int):
	current_player_name = currentUserTextEdit.text
	currentUserTextEdit.clear()
	save_score(final_score, final_time)

func on_toggle_score_window(visibility: bool):
	self.visible = visibility

func save_score(final_score: int, final_time: int):
	var file = FileAccess.open(GlobalVars.SCORE_TABLE_FILE_PATH, FileAccess.WRITE_READ)

	var score_line: Dictionary = {
		"Name": current_player_name, 
		"Score": final_score, 
		"time": final_time, 
		"datetime": Time.get_datetime_string_from_system()
	}
	
	GlobalVars.current_scores[GlobalVars.settings.dificulty].scores.append(score_line)

	if GlobalVars.current_scores[GlobalVars.settings.dificulty].highest_score < final_score:
		GlobalVars.current_scores[
			GlobalVars.settings.dificulty
		].highest_score = final_score

	GlobalVars.current_scores[
		GlobalVars.settings.dificulty
	].last_player_name = current_player_name

	file.store_line(JSON.stringify(GlobalVars.current_scores, "\t"))
	file.close()
	currentUserTextEdit.clear()

	self.visible = false

func on_game_won():
	if GlobalVars.current_scores[GlobalVars.settings.dificulty].last_player_name:
		currentUserTextEdit.insert_text_at_caret(
			GlobalVars.current_scores[GlobalVars.settings.dificulty].last_player_name
		)
	self.visible = true

func on_game_start():
	self.visible = false
