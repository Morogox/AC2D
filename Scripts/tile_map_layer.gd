extends TileMapLayer
func _ready():
	var screen_size = get_viewport_rect().size
	var grid_size = get_parent().cell_size  # TileMap's cell_size (Vector2)
	
	# Calculate how many tiles we need
	var tiles_x = int(screen_size.x / grid_size.x) + 1
	var tiles_y = int(screen_size.y / grid_size.y) + 1
	
	for x in range(tiles_x):
		for y in range(tiles_y):
			set_cell(Vector2i(x, y), 2)  # 0 = first tile in TileSet
