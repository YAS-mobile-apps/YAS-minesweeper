@tool

extends HBoxContainer
class_name TableRow

@export var player_name : String = ""
@export var score : String = ""
@export var player_time : String = ""
@export var datetime : String = ""

@onready var m_NodeColumnName : Label = get_node("ColumnName")
@onready var m_NodeColumnScore : Label = get_node("ColumnScore")
@onready var m_NodeColumnTime : Label = get_node("ColumnTime")
@onready var m_NodeColumnDatetime : Label = get_node("ColumnDatetime")


func _ready():
	set_row(player_name, score, player_time, datetime)


func set_row(player_name : String, score : String, player_time: String, datetime: String) -> void:
	m_NodeColumnName.set_text(player_name)
	m_NodeColumnScore.set_text(score)
	m_NodeColumnTime.set_text(player_time)
	m_NodeColumnDatetime.set_text(datetime)
