extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	game_controller.current_skelly = 0
	var lvl_str = "res://Levels/Lvl" + str(game_controller.level) + ".tscn"
	get_tree().change_scene(lvl_str)
	hide_all()
	game_controller.close_shop()
	game_controller.max_health_c=game_controller.max_health_o
	game_controller.max_skelly_c = game_controller.max_skelly_o
	game_controller.max_skull_dam_c = game_controller.max_skull_dam_o
	game_controller.max_skelly_health_c = game_controller.max_skelly_health_o
	game_controller.max_skelly_health_c = game_controller.max_skelly_health_o
	game_controller.max_skelly_damage_c = game_controller.max_skelly_damage_o
	game_controller.currency = game_controller.currency_stored

	
	game_controller.updage_ui()


func _on_CheckButton_pressed():
	$AudioStreamPlayer2D.playing = $CenterContainer/VBoxContainer/CheckButton.pressed


func _on_Exit_pressed():
	game_controller.close_menu()


func hide_all():
	$ColorRect.hide()
	$CenterContainer.hide()

func show_all():
	$ColorRect.show()
	$CenterContainer.show()
