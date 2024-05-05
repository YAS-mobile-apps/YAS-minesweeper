extends Node

const COUNTERS_FONT_COLOUR: String = "#a10000"
const SCORE_TABLE_FILE_PATH: String = "user://score_table.json"
const SETTINGS_FILE_PATH: String = "user://settings.json"
const SCORE_LIST_MAX_SIZE: int = 200


var settings: Dictionary = {
	"dificulty": "dev_mode",
	"hold_click": "long",
	"click_reverse": false,
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

const PRESSED_ID: Dictionary = {
	0:"normal_mode",
	1:"medium_mode",
	2:"hard_mode"
}

const DIFICULTY_ID: Dictionary = {
	"normal_mode":0,
	"medium_mode":1,
	"hard_mode":2,
	"dev_mode":0
}

const HOLD_TIMER_ID: Dictionary = {
	0:"short",
	1:"medium",
	2:"long"
}

const HOLD_TIMER_LABELS: Dictionary = {
	"short":0,
	"medium":1,
	"long":2,
}
