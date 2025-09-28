extends TileMapLayer

var height = -100
var rise_speed = 1

func update():
	# iterate through on screen tiles in the tilemap
	for x in range(-100,100):
		for y in range(-100,100):
			var height_vector = $"../HeightMap".get_cell_atlas_coords(Vector2i(x,y))
			var tile_height = height_vector.y * 32 + height_vector.x
			if tile_height < height:
				set_cell(Vector2i(x,y), 0, Vector2i(0,0))
			else:
				erase_cell(Vector2i(x,y))

func _physics_process(delta: float) -> void:
	var player_pos : Vector2 = $"../Player".position
	player_pos /= 16
	if get_cell_source_id(player_pos) == 0: $"../Player".health = 0
	height += rise_speed * delta
	update()
