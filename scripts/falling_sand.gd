extends TileMapLayer

var height = 1000
var fall_speed = 1

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
	height -= fall_speed * delta
	
	update()
