extends Node2D

onready var shop_node = preload("res://UI/Shop.tscn")
onready var menu_node = preload("res://UI/Menu.tscn")

var shop_instance
var menu_instance

var menu_opened = false

signal resource_selected
signal resouce_reached
signal enemy_clicked
signal update_ui
signal grave_clicked

var skellys : int 
var ClickedEnemy
var player
var player_health : float

var UI

var max_skelly : int = 1
var current_skelly : int = 0
var currency : int = 0
var currency_stored : int = 0
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
var max_skelly_damage_v : int = 10

var level : int = -1
var max_levels : int =6

func _ready():
	menu_instance = menu_node.instance()
	menu_instance.hide_all()
	add_child(menu_instance)

func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		if menu_opened:
			close_menu()
		else:
			show_menu()

func enemy_clicked(body : KinematicBody2D):
	ClickedEnemy = body
	emit_signal("enemy_clicked")


func set_player_health(health : float):
	player_health = health
	UI.set_health()


func updage_ui():
	emit_signal("update_ui")

func show_menu():
	if not menu_opened:
		menu_instance.show_all()
		menu_opened = true

		get_tree().paused = true


func close_menu():
	menu_instance.hide_all()
	get_tree().paused = false
	menu_opened = false


func show_shop():
	shop_instance = shop_node.instance()
	add_child(shop_instance)
	get_tree().paused = true

func close_shop():
	remove_child(shop_instance)
	get_tree().paused = false
