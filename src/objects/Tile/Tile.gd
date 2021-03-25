extends Pickable_sprite
class_name Tile

var Open_piece_indicator = load("res://src/objects/Open_piece_indicator/Open_piece_indicator.tscn")


#   position
var type = 0
var variation = 0
var orientation = 0

var occupiable_sections = {}
var occupied_info = null


signal snap_requested()


func attempt_snap(player_piece):
	var distance = position - player_piece.position
	if abs(distance.x) < 1.2*Globals.tile_size and abs(distance.y) < 1.2*Globals.tile_size and occupiable_sections:
		occupied_info = Occupied_info.new()
		var closest_area_position = null
		for structure_type in occupiable_sections.keys():
			for section in occupiable_sections[structure_type]:
				for area in section:
					var area_position = Globals.get_area_position(structure_type, area)
					if closest_area_position == null or (position + area_position - player_piece.position).length() < (position + closest_area_position - player_piece.position).length():
						closest_area_position = area_position
						occupied_info.set_info(structure_type, section, player_piece.weight, player_piece.player)
		player_piece.position = position + closest_area_position
		#add_child(player_piece)
		return true
	occupied_info = null
	#detach child
	return false


func show_open_positions():
	for structure_type in occupiable_sections.keys():
			for section in occupiable_sections[structure_type]:
				for area in section:
					var area_position = Globals.get_area_position(structure_type, area)
					var indicator = Open_piece_indicator.instance()
					add_child(indicator)
					indicator.position = area_position


func _process(delta):
	_update()


func _update():
	get_node("Sprite").region_rect.position = Vector2(256*variation, 256*type)
	get_node("Active_indicator").visible = pickable
	rotation_degrees = 90*orientation


func _on_Click_detector_clicked(button_index, pressed):
	._on_Click_detector_clicked(button_index, pressed)
	if button_index in [BUTTON_LEFT, BUTTON_RIGHT] and not pressed and pickable:
		emit_signal('snap_requested')
	if button_index == BUTTON_RIGHT and pressed and pickable:
		orientation = (orientation + 1) % 4


func _on_Player_piece_snap_requested(player_piece):
	attempt_snap(player_piece)
