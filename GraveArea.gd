extends Area2D

onready var shop_dialogue = preload("res://ShopDialogue.tscn")

var inst 

var in_range = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("open_shop") and in_range:
		game_controller.show_shop()
		remove_child(inst)


func _on_GraveArea_body_entered(body):
	print(body)
	if body.is_in_group("Undead"):
		game_controller.skellys += 1
		body.return_to_grave()
	if body.is_in_group("Player"):
		inst = shop_dialogue.instance()
		in_range = true
		add_child(inst)


func _on_GraveArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		game_controller.emit_signal("grave_clicked")


func _on_GraveArea_body_exited(body):
	if body.is_in_group("Player"):
		remove_child(inst)
		in_range = false
