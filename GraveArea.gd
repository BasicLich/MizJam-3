extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GraveArea_body_entered(body):
	print(body)
	if body.is_in_group("Undead"):
		game_controller.skellys += 1
		body.return_to_grave()
	if body.is_in_group("Player"):
		game_controller.show_shop()
