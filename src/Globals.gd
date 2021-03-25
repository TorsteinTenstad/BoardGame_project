extends Node

var tile_size = 256
var tile_dimensions = Vector2(256,256)

var adjacent_nudges = [Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0), Vector2(0, 1)]

var tile_info = {0: {},
				1: {1: [[0, 2]], 2: [[1]], 3: [[0, 3], [4, 5, 6, 7]]},
				3: {1: [[2, 3]], 2: [[1]], 3: [[0, 3, 6, 7], [4, 5]]},
				13: {1: [[0, 3]], 2: [[1, 2]], 3: [[0, 5], [6, 7]]},
				18: {1: [[3]], 3: [[0, 1, 2, 3, 4, 5, 6, 7]], 4: [[0]]}
				}

var number_of_areas = {1: 4, 2: 4, 3: 9, 4: 1}

var connected_areas = {}
var player_piece_positions = {}
var tile_edges = {}

func _ready():
	#connected_areas:
	for tile_id in tile_info.keys():
		var tile_dict = {}
		for structure_type in tile_info[tile_id].keys():
			var structure_dict = {}
			for group in tile_info[tile_id][structure_type]:
				for area in group:
					structure_dict[area] = group
			tile_dict[structure_type] = structure_dict
		connected_areas[tile_id] = tile_dict

	#player_piece_positions:
	for tile_id in tile_info.keys():
		var tile_dict = {}
		for structure_type in tile_info[tile_id].keys():
			var positions = []
			for i in range(number_of_areas[structure_type]):
				positions += [0]
			for group in tile_info[tile_id][structure_type]:
				for area in group:
					positions[area] = 1
			tile_dict[structure_type] = positions
		player_piece_positions[tile_id] = tile_dict

	#tile_edges:
	for tile_id in tile_info.keys():
		var edges = [3, 3, 3, 3]
		for structure_type in tile_info[tile_id].keys():
			if structure_type in [1, 2]:
				for group in tile_info[tile_id][structure_type]:
					for area in group:
						edges[area] = structure_type
		tile_edges[tile_id] = edges
	tile_edges[0] = [0, 0, 0, 0]


func get_area_position(structure_type, area):
	if structure_type == 1 or structure_type == 2:
		return Vector2(tile_size/2,0).rotated(-area*PI/2)
	elif structure_type == 3:
		if area == 8:
			return Vector2(0,0)
		else:
			return Vector2(tile_size/2,0).rotated(-area*PI/4 - PI/8)
	elif structure_type == 4 and area == 0:
		return Vector2(0,0)


func add_dictionarys(dict_a, dict_b):
	for key in dict_b.keys():
		if key in dict_a.keys():
			dict_a[key] += dict_b[key]
		else:
			dict_a[key] = dict_b[key]
	return dict_a
