extends PanelContainer

class_name BaseNode

var base_tileset: TileSet

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	ThemeManager.apply(self, "oceanBlue")
	base_tileset = create_tileset(get_theme().get_meta("base_tiles"))


func create_tileset(tile_theme: Texture2D) -> TileSet:
	base_tileset = TileSet.new()
	base_tileset.tile_size = GlobalVars.TILE_SIZE
	
	var atlas_source = TileSetAtlasSource.new()
	atlas_source.texture_region_size = GlobalVars.TILE_SIZE
	atlas_source.texture = tile_theme

	var texture_size = tile_theme.get_size()
	var tiles_x = texture_size.x / GlobalVars.TILE_SIZE.x

	for x in range(tiles_x):
		atlas_source.create_tile(Vector2i(x, 0))

	atlas_source.create_alternative_tile(GlobalVars.CELLS.default)
	base_tileset.add_source(atlas_source)
	return base_tileset

func get_tile_texture(coords: Vector2i) -> Texture2D:
	var source := base_tileset.get_source(0) as TileSetAtlasSource
	
	var atlas := AtlasTexture.new()
	atlas.atlas = source.texture
	atlas.region = Rect2i(coords * GlobalVars.TILE_SIZE, GlobalVars.TILE_SIZE)
	
	return atlas
