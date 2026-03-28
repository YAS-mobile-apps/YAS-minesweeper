extends Node

var themes: Dictionary = {
	"development": preload("res://assets/themes/dev_theme/development_theme.tres"),
	"default": preload("res://assets/themes/default_theme/default_theme.tres"),
	"blueOcean": preload("res://assets/themes/1_blueOcean_theme/blueOcean_theme.tres"),
	"greenFlowerField": preload("res://assets/themes/2_greenFlowerField_theme/greenFlowerField_theme.tres"),
	"yellowBeach": preload("res://assets/themes/3_yellowBeach_theme/yellowBeach_theme.tres"),
	"brownDesert": preload("res://assets/themes/4_brownDesert_theme/brownDesert_theme.tres"),
	"orangeLavaField": preload("res://assets/themes/5_orangeLavaField_theme/orangeLavaField_theme.tres"),
	"purpleTech": preload("res://assets/themes/6_purpleTech_theme/purpleTech_theme.tres"),
	"nightSky": preload("res://assets/themes/7_nightSky_theme/nightSky_theme.tres"),
	"goldAscendency": preload("res://assets/themes/8_goldAscendency_theme/goldAscendency_theme.tres"),
}

var active_themes: Array = GlobalVars.settings.active_themes
var current_theme_name: String = GlobalVars.settings.current_theme
var current_theme: Theme = themes[current_theme_name]
var game_lost_button = get_game_lost_button()
var game_won_button = get_game_won_button()
var default_button = get_default_button()
var tileset = get_tileset(true)

signal theme_changed(theme_name: String)


func change_global_theme(theme_name: String):
	current_theme_name = theme_name
	current_theme = themes[theme_name]
	game_lost_button = get_game_lost_button(true)
	game_won_button = get_game_won_button(true)
	default_button = get_default_button(true)
	tileset = get_tileset(true)
	theme_changed.emit(theme_name)


func apply(root: Control, theme_name: String) -> Theme:
	root.theme = themes[theme_name]
	current_theme = themes[theme_name]
	return themes[theme_name]


func get_metadata(metadata: String, theme_name: String = ""):
	if theme_name:
		return themes[theme_name].get_meta(metadata)
	return current_theme.get_meta(metadata)


func get_font(font_type: String, theme_name: String = "") -> Font:
	if theme_name:
		return themes[theme_name].get_font("font", font_type)
	return current_theme.get_font("font", font_type)


func get_tileset(refresh: bool = false):
	if not tileset or refresh == true:
		_innit_tileset()
	return tileset


func _innit_tileset():
	tileset = TileSet.new()
	tileset.tile_size = GlobalVars.TILE_SIZE
	
	var atlas_source = TileSetAtlasSource.new()
	var tile_theme = current_theme.get_meta("base_tiles")
	atlas_source.texture_region_size = GlobalVars.TILE_SIZE
	atlas_source.texture = tile_theme

	var texture_size = tile_theme.get_size()
	var tiles_x = texture_size.x / GlobalVars.TILE_SIZE.x

	for x in range(tiles_x):
		atlas_source.create_tile(Vector2i(x, 0))

	atlas_source.create_alternative_tile(GlobalVars.CELLS.default)
	tileset.add_source(atlas_source)
	return self


func get_current_theme() -> Theme:
	return current_theme


func get_current_theme_name() -> String:
	return current_theme_name


func get_tile_texture(coords: Vector2i) -> Texture2D:
	if not tileset:
		_innit_tileset()
	
	var source := tileset.get_source(0) as TileSetAtlasSource
	
	var atlas := AtlasTexture.new()
	atlas.atlas = source.texture
	atlas.region = Rect2i(coords * GlobalVars.TILE_SIZE, GlobalVars.TILE_SIZE)
	
	return atlas


func get_game_lost_button(refresh: bool = false) -> StyleBoxTexture:
	if not game_lost_button or refresh == true:
		_innit_button("lose", GlobalVars.CELLS.lose)
	return game_lost_button


func get_game_won_button(refresh: bool = false) -> StyleBoxTexture:
	if not game_won_button or refresh == true:
		_innit_button("win", GlobalVars.CELLS.win)
	return game_won_button


func get_default_button(refresh: bool = false) -> StyleBoxTexture:
	if not default_button or refresh == true:
		_innit_button("smile", GlobalVars.CELLS.smile)
	return default_button


func _innit_button(button_key: String, button_position: Vector2):
	var tile_texture = get_tile_texture(button_position)

	if button_key == "win":
		game_won_button = StyleBoxTexture.new()
		game_won_button.texture = tile_texture

	if button_key == "lose":
		game_lost_button = StyleBoxTexture.new()
		game_lost_button.texture = tile_texture

	if button_key == "smile":
		default_button = StyleBoxTexture.new()
		default_button.texture = tile_texture
