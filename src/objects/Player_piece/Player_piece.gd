extends Pickable_sprite
class_name Player_piece

export var player = 0
export var weight = 1


var grid


signal snap_requested(player_piece)


func _ready():
	grid = get_node("../Grid")


func _update():
	get_node("Sprite").region_rect.position = Vector2(0, 64*player)


func _on_Click_detector_clicked(button_index, pressed):
	._on_Click_detector_clicked(button_index, pressed)
	if button_index in [BUTTON_LEFT] and not pressed:
		self.connect('snap_requested', grid.free_tile, '_on_Player_piece_snap_requested')
		emit_signal('snap_requested', self)
