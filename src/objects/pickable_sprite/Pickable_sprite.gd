extends Node2D
class_name Pickable_sprite


#   position
export var move_button = BUTTON_LEFT
export var pickable = true
export var invert_boarder = false

var _follow_curser = false
var _drag_start_pos = Vector2(0,0)


func _ready():
	get_node("Boarder").visible = invert_boarder


func _process(delta):
	if _follow_curser:
		position = get_global_mouse_position() - _drag_start_pos


func _on_Click_detector_clicked(button_index, pressed):
	if button_index == move_button and pickable:
		click(pressed)


func click(pressed):
		_drag_start_pos = get_global_mouse_position() - position
		_follow_curser = pressed
		get_node("Boarder").visible = pressed != invert_boarder
