extends Node2D

var warrior_node = preload("res://Units/Friendly/warrior_1/warrior_1.tscn")

var is_in_range : bool = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RaiseArea_body_entered(body):
	if body.is_in_group("Player"):
		$CPUParticles2D.emitting = true
		is_in_range = true
		game_controller.player.bones_ir.append(self)
		

func _on_RaiseArea_body_exited(body):
	if body.is_in_group("Player"):
		$CPUParticles2D.emitting = false
		is_in_range = false
		game_controller.player.bones_ir.erase(self)


func raise_skelly():
		var skelly_instance = warrior_node.instance()
		skelly_instance.position = position
		skelly_instance.scale = Vector2(0.1,0.1)
		get_parent().add_child(skelly_instance)
		skelly_instance.raise()
		queue_free()
