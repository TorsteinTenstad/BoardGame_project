class_name Structures_handler


var structures = {1: {}, 2: {}, 3: {}, 4: {}}
var _next_free_id = {1: 0, 2: 0, 3: 0, 4: 0}
var grid_refrence


func get_structure_id(structure_type, grid_pos, area):
	for id in structures[structure_type].keys():
		if structures[structure_type][id].covers(grid_pos, area):
			return id
	print("No structure found at ", grid_pos, " in area ", area, " with structure type ", structure_type)
	return null


func get_ownership(structure_type, structure_id):
	if structure_id:
		return structures[structure_type][structure_id].ownership
	else:
		return null


func update(tile_id, tile_orientation, grid_pos, occupied_info):
	for structure_type in Globals.tile_info[tile_id].keys():
		for section in Globals.tile_info[tile_id][structure_type]:
			var player = null
			var pieces = null
			if occupied_info and structure_type == occupied_info.structure_type and section == occupied_info.section:
				player = occupied_info.player
				pieces = occupied_info.pieces
			var connected_structure_ids = []
			for area in section:
				var neigbour_area_id = get_neigbour_id(structure_type, grid_pos, area, tile_orientation)
				if neigbour_area_id and not neigbour_area_id in connected_structure_ids:
					connected_structure_ids.append(neigbour_area_id)
			if connected_structure_ids:
				for i in range(1, connected_structure_ids.size()):
					structures[structure_type][connected_structure_ids[0]].join(structures[structure_type][connected_structure_ids[i]])
					structures[structure_type].erase(connected_structure_ids[i])
				structures[structure_type][connected_structure_ids[0]].expand(grid_pos, section, player, pieces)
			else:
				add_sturcture(Structure.new().initialize(structure_type, grid_pos, section, player, pieces))


func get_neigbour(structure_type, grid_pos, area, tile_orientation):
	var neigbour_area = [null, null] #[grid_pos, area]
	var neigbour_tile_orientation
	if structure_type in [1, 2]:
		neigbour_area[0] = grid_pos + Globals.adjacent_nudges[(4 + area - tile_orientation) % 4]
		neigbour_tile_orientation = grid_refrence.get_tile_orientation(neigbour_area[0])
		if neigbour_tile_orientation == null:
			return null
		neigbour_area[1] = (area - tile_orientation + 2 + neigbour_tile_orientation + 4) % 4
	if structure_type == 3:
		neigbour_area[0] = grid_pos + Globals.adjacent_nudges[(4 + int(ceil(float(area)/2)) - tile_orientation) % 4]
		neigbour_tile_orientation = grid_refrence.get_tile_orientation(neigbour_area[0])
		if neigbour_tile_orientation == null:
			return null
		neigbour_area[1] = (((area - 2 * tile_orientation) + 4 + {0: -1, 1: 1}[(area - 2 * tile_orientation + 8) % 2]) + 2 * neigbour_tile_orientation + 8) % 8
	if structure_type == 4 or area == 8:
			return null
	return neigbour_area


func get_neigbour_id(structure_type, grid_pos, area, tile_orientation):
	var neigbour_area = get_neigbour(structure_type, grid_pos, area, tile_orientation)
	if neigbour_area:
		return get_structure_id(structure_type, neigbour_area[0], neigbour_area[1])
	else:
		return null


func add_sturcture(structure):
	structures[structure.structure_type][_next_free_id[structure.structure_type]] = structure
	_next_free_id[structure.structure_type] += 1
