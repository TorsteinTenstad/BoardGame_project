extends Node2D

var Tile = load("res://src/objects/Tile/Tile.tscn")

var _grid = {}
var free_tile = null
var free_tile_is_snapped = false

var structure_handler

signal ready_for_tile


func _ready():
	structure_handler = Structures_handler.new()
	structure_handler.grid_refrence = self
	free_tile = Tile.instance()
	free_tile.type = 1
	add_child(free_tile)
	lock_free_tile(Vector2(0,0))

func _to_grid_pos(position):
	return ((position+Globals.tile_dimensions/Vector2(2,2))/Globals.tile_dimensions).floor()


func get_tile_orientation(grid_pos):
	if grid_pos in _grid.keys() and _grid[grid_pos].type != 0:
		return _grid[grid_pos].orientation
	else:
		return null


func attempt_snap():
	free_tile_is_snapped = false
	var grid_pos = _to_grid_pos(free_tile.position)
	if grid_pos in _grid.keys():
		if _grid[grid_pos].type == 0:
			for i in range(4):
				if grid_pos + Globals.adjacent_nudges[i] in _grid.keys():
					var surrounding_tile = _grid[grid_pos + Globals.adjacent_nudges[i]]
					var surrounding_edge = Globals.tile_edges[surrounding_tile.type][(i + surrounding_tile.orientation + 2) % 4]
					if surrounding_edge and Globals.tile_edges[free_tile.type][(i + free_tile.orientation) % 4] != surrounding_edge:
						return
			free_tile.position = grid_pos*Globals.tile_dimensions
			free_tile_is_snapped = true
			return grid_pos


func lock_free_tile(grid_pos):
	free_tile.pickable = false
	_grid[grid_pos] = free_tile
	structure_handler.update(free_tile.type, free_tile.orientation, grid_pos, free_tile.occupied_info)
	free_tile = null
	free_tile_is_snapped = false
	emit_signal("ready_for_tile")
	_create_empty_tiles(grid_pos)


func _create_empty_tiles(grid_pos):
	for nudge in Globals.adjacent_nudges:
			if not grid_pos + nudge in _grid.keys():
				var empty_tile = Tile.instance()
				empty_tile.get_node("Sprite").z_index = 0
				empty_tile.pickable = false
				empty_tile.position = (grid_pos + nudge)*Globals.tile_dimensions
				_grid[grid_pos + nudge] = empty_tile
				add_child(empty_tile)


func _on_Tile_snap_requested():
	attempt_snap()


func _on_Stack_tile_delivered(tile):
	free_tile = tile
	add_child(tile)


func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ENTER and event.pressed:
			var grid_position = attempt_snap()
			if grid_position:
				lock_free_tile(grid_position)
