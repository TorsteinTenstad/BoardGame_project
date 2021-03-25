extends "res://src/objects/pickable_sprite/Pickable_sprite.gd"


var Tile = load("res://src/objects/Tile/Tile.tscn")
var grid
var can_create_tile = true


var rng = RandomNumberGenerator.new()


signal tile_delivered(tile)

func _ready():
	rng.randomize()
	move_button = BUTTON_RIGHT
	grid = get_node("../Grid")


func _on_Click_detector_clicked(button_index, pressed):
	._on_Click_detector_clicked(button_index, pressed)
	if button_index == BUTTON_LEFT and pressed:
		_add_tile()


func _add_tile():
	if can_create_tile:
		var tile = Tile.instance()
		tile.connect('snap_requested', grid, '_on_Tile_snap_requested')
		tile.type = [1, 3, 13, 18][rng.randi_range(0,3)]
		tile.pick(BUTTON_LEFT, true)
		emit_signal('tile_delivered', tile)
		can_create_tile = false


func _on_Grid_ready_for_tile():
	can_create_tile = true
