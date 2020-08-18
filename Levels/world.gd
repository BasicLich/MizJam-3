extends Node2D

onready var nav_2d : Navigation2D = $Navigation2D

var dragging = false
var selected = []
var selected_wr = {}
var drag_start = Vector2.ZERO
var select_rect = RectangleShape2D.new()

signal path_requested
var mousePos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


 
func _unhandled_input(event : InputEvent) -> void:
#	if not event is InputEventMouseButton:
#		return
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		emit_signal("path_requested")
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			if selected.size() == 0:
				dragging = true
				drag_start = get_global_mouse_position()
			else:
				for item in selected:
					if is_instance_valid(item.collider): 
						if item.collider.is_in_group("Friendly"):
							item.collider.is_selected = false
				dragging = true
				drag_start = get_global_mouse_position()
				selected = []
				selected_wr = []
		elif dragging:
			dragging = false
			update()
			var drag_end = get_global_mouse_position()
			select_rect.extents = (drag_end - drag_start) / 2
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape((select_rect))
			query.transform = Transform2D(0, (drag_end + drag_start) / 2)
			selected = space.intersect_shape(query)
			for item in selected:
				if item.collider.is_in_group("Friendly"):
					item.collider.is_selected = true
	if event is InputEventMouseMotion and dragging:
		update()


func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position()-drag_start),
			Color(0.5,1.0,0.5), false)



func request_path(actor_position : Vector2, target : Vector2):
	var new_path : = nav_2d.get_simple_path(actor_position, target)
	return new_path


	
