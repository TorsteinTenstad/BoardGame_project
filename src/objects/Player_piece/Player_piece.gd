extends Pickable_sprite
class_name Player_piece

export var player = 0
export var weight = 1


var grid


signal snap_requested(player_piece)


func _ready():
	grid = get_node("../Grid")
	#print(get_node("Click_detector").get_shape_owners())
	#get_node("Click_detector").shape_owner_get_shape(0, 0).set_extents(Vector2(32, 32))


func _update():
	get_node("Sprite").region_rect.position = Vector2(0, 64*player)


func _on_Click_detector_clicked(button_index, pressed):
	._on_Click_detector_clicked(button_index, pressed)
	if button_index in [BUTTON_LEFT, BUTTON_RIGHT] and not pressed:
		self.connect('snap_requested', grid.free_tile, '_on_Player_piece_snap_requested')
		emit_signal('snap_requested', self)
