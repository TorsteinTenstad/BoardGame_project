class_name Structure


var structure_type
var sections = {}
var ownership = {}

func initialize(structure_type0, grid_pos, section, player, pieces):
	structure_type = structure_type0
	sections = {grid_pos: section}
	if player:
		ownership = {player: pieces}
	return self


func expand(grid_pos, section, player, pieces):
	if grid_pos in sections.keys():
		sections[grid_pos] += section
	else:
		sections[grid_pos] = section
	if player:
		ownership[player] = pieces


func join(structure):
	sections = Globals.add_dictionarys(sections, structure.sections)
	ownership = Globals.add_dictionarys(ownership, structure.ownership)


func covers(grid_pos, area):
	if grid_pos in sections.keys() and area in sections[grid_pos]:
		return true
	else:
		return false

func print():
	print({1: "Road: ", 2: "Castle: ", 3: "Field: ", 4: "Monastery"}[structure_type])
	for grid_pos in sections.keys():
		print(grid_pos, ': ', sections[grid_pos])
