extends Camera2D


export var zoom_step = 1.1
export var panSpeed = 25.0
export var pan_margin = 0.9

var normalized_mousepos = Vector2()
var inp_x = 0
var inp_y = 0


func _input(event):
	if event is InputEventMouse:
		if event.is_pressed() and not event.is_echo():
			var mouse_position = event.position
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom_at_point(zoom_step,mouse_position)
			else : if event.button_index == BUTTON_WHEEL_UP:
				zoom_at_point(1/zoom_step,mouse_position)
		normalized_mousepos = 2*event.position/get_viewport().size - Vector2(1,1)
		inp_x = 0 if abs(normalized_mousepos.x) < pan_margin else sign(normalized_mousepos.x)*(abs(normalized_mousepos.x)-pan_margin)/(1-pan_margin)
		inp_y = 0 if abs(normalized_mousepos.y) < pan_margin else sign(normalized_mousepos.y)*(abs(normalized_mousepos.y)-pan_margin)/(1-pan_margin)


func _process(delta):
	position.x = lerp(position.x, position.x + inp_x *panSpeed * zoom.x,panSpeed * delta)
	position.y = lerp(position.y, position.y + inp_y *panSpeed * zoom.y,panSpeed * delta)


func zoom_at_point(zoom_change, point):
	global_position = global_position + (-0.5*get_viewport().size + point)*zoom*(1 - zoom_change)
	zoom = zoom * zoom_change
