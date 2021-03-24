extends Area2D


var trigger_on = [BUTTON_LEFT, BUTTON_RIGHT]
export var size = Vector2(128, 128)

signal clicked(button_index, pressed)



func _ready():
	scale = size


func _on_Click_detector_input_event(viewport, event, shape_idx):
	get_tree().set_input_as_handled()
	if event is InputEventMouseButton:
		if event.button_index in trigger_on:
#			var shapes = get_world_2d().direct_space_state.intersect_point(get_global_mouse_position(), 32, [], 0x7FFFFFFF, true, true) # The last 'true' enables Area2D intersections, previous four values are all defaults
#			print(shapes[0]['rid'].get_id(), "   ", get_rid().get_id())
#			if shapes[0]['rid'].get_id() == get_rid().get_id():
			emit_signal('clicked', event.button_index, event.pressed)
