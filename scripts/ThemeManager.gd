extends Node

var themes := {
	"default": preload("res://assets/themes/default_theme/default_theme.tres"),
	"development": preload("res://assets/themes/dev_theme/development_theme.tres")
}

var current_theme: Theme

func apply(root: Control, theme_name: String):
	root.theme = themes[theme_name]
	current_theme = themes[theme_name]
	return themes[theme_name]


func get_metadata(metadata: String):
	return current_theme.get_meta(metadata)


func get_font(font_type: String):
	return current_theme.get_font("font", font_type)

func get_tileset():
	pass