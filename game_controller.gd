extends Node2D

signal resource_selected
signal resouce_reached
signal enemy_clicked

var ClickedEnemy
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enemy_clicked(body : KinematicBody2D):
	ClickedEnemy = body
	emit_signal("enemy_clicked")
	
