extends TileMap

var selected_cell
var loc


# Called when the node enters the scene tree for the first time.
func _ready():
	game_controller.connect("resouce_reached",self, "_harvest_resource")


func _input(event):
	if event.is_action_pressed('right_click'):
		var mousePos = get_global_mouse_position()
		loc = world_to_map(mousePos)
		selected_cell = get_cell(loc.x,loc.y)

func _harvest_resource():
	print(selected_cell)
	match selected_cell:
		1: #Wood
			print("+1 Lumber")
			set_cell(loc.x, loc.y, 0)
