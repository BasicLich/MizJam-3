extends Camera2D

export var speed = 20
export var zoomspeed= 20.0
export var zoommargin = 0.1

var zoompos = Vector2()
var zoomfact = 1.0

var zoomMin = 0.1
var zoomMax = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var inpx = ( int(Input.is_action_pressed("pan_right")) 
	- int(Input.is_action_pressed("pan_left")) )
	position.x = lerp(position.x, position.x + inpx*speed*zoom.x, speed*delta)
	
	var inpy = ( int(Input.is_action_pressed("pan_down")) 
	- int(Input.is_action_pressed("pan_up")) )
	position.y = lerp(position.y, position.y + inpy*speed * zoom.y, speed*delta)

	zoom.x = lerp(zoom.x, zoom.x * zoomfact, zoomspeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomfact, zoomspeed * delta)
	
	zoom.x = clamp(zoom.x, zoomMin, zoomMax)
	zoom.y = clamp(zoom.y, zoomMin, zoomMax)
	
	zoomfact = 1.0
	
func _input(event):
	if abs(zoompos.x - get_global_mouse_position().x )> zoommargin:
		zoomfact = 1.0
	if abs(zoompos.y - get_global_mouse_position().y )> zoommargin:
		zoomfact = 1.0
		
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoomfact -= 0.2
				zoompos = get_global_mouse_position()
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoomfact += 0.2
				zoompos = get_global_mouse_position()
				
				
