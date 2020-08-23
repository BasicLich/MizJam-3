extends Node2D

onready var shop_node = preload("res://UI/Shop.tscn")
var shop_instance

signal resource_selected
signal resouce_reached
signal enemy_clicked
signal update_ui

var skellys : int 
var ClickedEnemy
var player
var player_health : float

var UI

var max_skelly : int = 1
var current_skelly : int = 0
var currency : int = 500
var total_villagers: int = 5
var villagers_left : int = total_villagers

# Shop Stuff
var max_health_n : int 
var max_health_o : int
var max_health_c : int = 0
var max_health_v : int = 100

var max_skelly_n : int
var max_skelly_o : int
var max_skelly_c : int = 0
var max_skelly_v : int = 1

var max_skull_dam_n : int
var max_skull_dam_o : int
var max_skull_dam_c : int = 0
var max_skull_dam_v : int = 50

var max_skelly_health_n : int
var max_skelly_health_o : int
var max_skelly_health_c : int = 0
var max_skelly_health_v : int = 50

var max_skelly_damage_n : int
var max_skelly_damage_o : int
var max_skelly_damage_c : int = 0
var max_skelly_damage_v : int = 20



func _ready():
	pass

func enemy_clicked(body : KinematicBody2D):
	ClickedEnemy = body
	emit_signal("enemy_clicked")


func set_player_health(health : float):
	player_health = health
	UI.set_health()


func updage_ui():
	emit_signal("update_ui")


func show_shop():
	print("SHOOP")
	shop_instance = shop_node.instance()
	add_child(shop_instance)
	get_tree().paused = true

func close_shop():
	remove_child(shop_instance)
	get_tree().paused = false
