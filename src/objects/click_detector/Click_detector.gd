extends Area2D


var trigger_on = [BUTTON_LEFT, BUTTON_RIGHT]
export var size = Vector2(128, 128)

signal clicked(button_index, pressed)



func _ready():
	scale = size


func _input(event):
	var local_mouse_pos = get_global_mouse_position() - global_position
	if abs(local_mouse_pos.x) <= size.x and abs(local_mouse_pos.y) <= size.y:
		if event is InputEventMouseButton:
			if event.button_index in trigger_on:
				emit_signal('clicked', event.button_index, event.pressed)
				get_tree().set_input_as_handled()
