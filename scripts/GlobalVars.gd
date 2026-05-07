extends Node

const COUNTERS_FONT_COLOUR: String = "#a10000"
const SCORE_TABLE_FILE_PATH: String = "user://score_table.json"
const SETTINGS_FILE_PATH: String = "user://settings.json"
const SCORE_LIST_MAX_SIZE: int = 200
const PRESSED_ID: Dictionary = {
	0:"normal_mode",
	1:"medium_mode",
	2:"hard_mode",
	3:"extra",
	4:"dev_mode",
}
const DIFICULTY_ID: Dictionary = {
	"normal_mode":0,
	"medium_mode":1,
	"hard_mode":2,
	"extra":3,
	"dev_mode":4,
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
const TILE_SIZE = Vector2i(49, 48)
const EMPTY_CELL_TILE_POSITION = 5;
const CELLS: Dictionary = {
	"open_cell": Vector2i(4, 0),
	"mine": Vector2i(0,0),
	"flag": Vector2i(1,0),
	"default": Vector2i(2,0),
	"mine_hit": Vector2i(3,0),
	"smile": Vector2i(6,0),
	"smile_click": Vector2i(7,0),
	"win": Vector2i(8,0),
	"lose": Vector2i(9,0),
	"winners": Vector2i(10,0),
	"winners_click": Vector2i(11,0),
	"themes": Vector2i(12,0),
	"themes_click": Vector2i(13,0),
	"settings": Vector2i(14,0)
}
const MINE_AMOUNT: Dictionary = {
	"dev_mode": 1,
	"normal_mode": 9,
	"medium_mode": 12,
	"hard_mode": 19,
	"extra": 29
}
const MOUSE_HOLD_TIMES: Dictionary = {
	"short": 0.200,
	"medium": 0.350,
	"long": 0.450,
}
const MENU_OPTIONS: Array = [
	"winners", 
	"themes"
]

var settings: Dictionary = {
	"dificulty": "normal_mode",
	"hold_click": "long",
	"click_reverse": false,
	"current_theme": "default",
	"active_themes": ["default", "blueOcean"],
	"achievements": {
		"numbers_found": {
			"1": 0,
			"2": 0,
			"3": 0,
			"4": 0,
			"5": 0,
			"6": 0,
			"7": 0,
			"8": 0,
		}
	}
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
	"extra":{
		"scores":[],
		"highest_score": 0,
		"last_player_name": "",
	},
}
