extends Node

const COUNTERS_FONT_COLOUR: String = "#a10000"
const SCORE_TABLE_FILE_PATH: String = "user://score_table.json"
const SETTINGS_FILE_PATH: String = "user://settings.json"
const SCORE_LIST_MAX_SIZE: int = 200

var current_scores: Dictionary = {
	"normal_mode":{
		"scores":[],
		"highest_score": 0,
		"lowest_score" : 0,
		"last_player_name": "",
	},
	"medium_mode":{
		"scores":[],
		"highest_score": 0,
		"lowest_score" : 0,
		"last_player_name": "",
	},
	"hard_mode":{
		"scores":[],
		"highest_score": 0,
		"lowest_score" : 0,
		"last_player_name": "",
	},
}
