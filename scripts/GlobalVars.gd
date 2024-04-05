extends Node

const COUNTERS_FONT_COLOUR: String = "#a10000"
const SCORE_TABLE_FILE_PATH: String = "user://score_table.json"
const SETTINGS_FILE_PATH: String = "user://settings.json"
const SCORE_LIST_MAX_SIZE: int = 200


var settings: Dictionary = {
	"dificulty": "dev_mode",
	"hold_click": "long",
	"click_reverse": false,
	"dude_key": 1,
}
var current_scores: Dictionary = {
	"dev_mode":{
		"scores":[],
		"highest_score": 0,
		"last_player_name": "",
	},
	"normal_mode":{
		"scores":[],
		"highest_score": 0,
		"last_player_name": "",
	},
	"medium_mode":{
		"scores":[],
		"highest_score": 0,
		"last_player_name": "",
	},
	"hard_mode":{
		"scores":[],
		"highest_score": 0,
		"last_player_name": "",
	},
}
