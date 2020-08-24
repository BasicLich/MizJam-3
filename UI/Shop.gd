extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var pl_health_inc : int = 10
var pl_skull_dmg_inc : int = 10
var sk_dmg_inc : int = 5

var mh_cost : int = 50
var ms_cost : int = 100
var sd_cost : int = 50

var smh_cost : int = 100
var skell_damage_cost : int = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	game_controller.max_health_o=game_controller.max_health_c
	game_controller.max_health_n=game_controller.max_health_c
	
	game_controller.max_skelly_o = game_controller.max_skelly_c
	game_controller.max_skelly_n = game_controller.max_skelly_c
	
	game_controller.max_skull_dam_n = game_controller.max_skull_dam_c
	game_controller.max_skull_dam_o = game_controller.max_skull_dam_c
	
	game_controller.max_skelly_health_o = game_controller.max_skelly_health_c
	game_controller.max_skelly_health_n = game_controller.max_skelly_health_c
	
	game_controller.max_skelly_damage_n = game_controller.max_skelly_damage_c
	game_controller.max_skelly_damage_o = game_controller.max_skelly_damage_c
	
	var cost = 100+ game_controller.max_health_n*mh_cost
	$Shop/PlayerUpgrades/Abilities/Health/VBoxContainer/HBoxContainer/MHCost.text=str(cost)
	$Shop/PlayerUpgrades/Abilities/Health/VBoxContainer/MHLabel.text= "Max Health: " + str(game_controller.max_health_v)


	
	cost = 100+ game_controller.max_skelly_n*ms_cost
	$Shop/PlayerUpgrades/Abilities/MaxSkelly/VBoxContainer/HBoxContainer/PMSCost.text=str(cost)
	$Shop/PlayerUpgrades/Abilities/MaxSkelly/VBoxContainer/PMSLabel.text= "Max Skelly: " + str(game_controller.max_skelly_v)
	
	cost = 100+ game_controller.max_skull_dam_n*sd_cost
	$Shop/PlayerUpgrades/Abilities/FlamingSkull/VBoxContainer/SDLabel.text = "Skull Damage: +" + str(game_controller.max_skull_dam_n)
	$Shop/PlayerUpgrades/Abilities/FlamingSkull/VBoxContainer/HBoxContainer/SDCost.text = str(cost)
	
	cost = 100+ game_controller.max_skelly_health_n*smh_cost
	$Shop/SkellyUpgrades/Abilities/Health/VBoxContainer/SKHLabel.text = "Max Health: " + str(game_controller.max_skelly_health_v)
	$Shop/SkellyUpgrades/Abilities/Health/VBoxContainer/HBoxContainer/SKHCost.text = str(cost)
	
	cost = 100+ game_controller.max_skelly_damage_n*skell_damage_cost
	$Shop/SkellyUpgrades/Abilities/MaxSkelly/VBoxContainer/DamageLabel.text = "Damage: +" + str(game_controller.max_skelly_damage_n)
	$Shop/SkellyUpgrades/Abilities/MaxSkelly/VBoxContainer/HBoxContainer/DamageCost.text = str(cost)

func _on_Close_pressed():
	game_controller.close_shop()
	game_controller.updage_ui()


func _on_MH_Up_pressed():
	var cost = 100+ game_controller.max_health_n*mh_cost
	if cost <= game_controller.currency:
		game_controller.currency -= cost
		game_controller.max_health_n += 1
		game_controller.max_health_c += 1
		game_controller.max_health_v += pl_health_inc
		var new_cost = cost + mh_cost
		$Shop/PlayerUpgrades/Abilities/Health/VBoxContainer/HBoxContainer/MHCost.text=str(new_cost)
		$Shop/PlayerUpgrades/Abilities/Health/VBoxContainer/MHLabel.text= "Max Health: " + str(game_controller.max_health_v)
		game_controller.updage_ui()


func _on_MH_Down_button_down():
	if game_controller.max_health_n > game_controller.max_health_o:
		var cost = 100+ (game_controller.max_health_n-1)*(mh_cost)
		game_controller.currency += cost
		game_controller.max_health_v -= pl_health_inc
		game_controller.max_health_n -= 1
		game_controller.max_health_c -= 1
		$Shop/PlayerUpgrades/Abilities/Health/VBoxContainer/HBoxContainer/MHCost.text=str(cost)
		$Shop/PlayerUpgrades/Abilities/Health/VBoxContainer/MHLabel.text= "Max Health: " + str(game_controller.max_health_v)
		game_controller.updage_ui()


func _on_PMS_Up_pressed():
	var cost = 100+ game_controller.max_skelly_n*ms_cost
	if cost <= game_controller.currency:
		game_controller.currency -= cost
		game_controller.max_skelly_n += 1
		game_controller.max_skelly_v += 1
		game_controller.max_skelly_c += 1
		game_controller.max_skelly +=1
		var new_cost = cost + ms_cost
		$Shop/PlayerUpgrades/Abilities/MaxSkelly/VBoxContainer/HBoxContainer/PMSCost.text=str(new_cost)
		$Shop/PlayerUpgrades/Abilities/MaxSkelly/VBoxContainer/PMSLabel.text= "Max Skelly: " + str(game_controller.max_skelly_v)
		game_controller.updage_ui()


func _on_PMS_down_pressed():
	if game_controller.max_skelly_n > game_controller.max_skelly_o:
		var cost = 100 + (game_controller.max_skelly_n-1)*(ms_cost)
		game_controller.currency += cost
		game_controller.max_skelly_n -= 1
		game_controller.max_skelly_v -= 1
		game_controller.max_skelly_c -= 1
		game_controller.max_skelly -=1
		var new_cost = cost + ms_cost
		$Shop/PlayerUpgrades/Abilities/MaxSkelly/VBoxContainer/HBoxContainer/PMSCost.text=str(cost)
		$Shop/PlayerUpgrades/Abilities/MaxSkelly/VBoxContainer/PMSLabel.text= "Max Skelly: " + str(game_controller.max_skelly_v)
		game_controller.updage_ui()


func _on_SkullUp_pressed():
	var cost = 100+ game_controller.max_skull_dam_n*sd_cost
	if cost <= game_controller.currency:
		game_controller.currency -= cost
		game_controller.max_skull_dam_n += 1
		game_controller.max_skull_dam_c += 1
		game_controller.max_skull_dam_v += pl_skull_dmg_inc
		var new_cost = cost + sd_cost
		$Shop/PlayerUpgrades/Abilities/FlamingSkull/VBoxContainer/SDLabel.text = "Skull Damage: +" + str(game_controller.max_skull_dam_n)
		$Shop/PlayerUpgrades/Abilities/FlamingSkull/VBoxContainer/HBoxContainer/SDCost.text = str(new_cost)
		game_controller.updage_ui()


func _on_SkullDown_pressed():
	if game_controller.max_skull_dam_n > game_controller.max_skull_dam_o:
		var cost = 100+ (game_controller.max_skull_dam_n-1)*sd_cost
		game_controller.currency += cost
		game_controller.max_skull_dam_n -= 1 
		game_controller.max_skull_dam_c -= 1 
		game_controller.max_skull_dam_v -=pl_skull_dmg_inc
		var new_cost = cost
		$Shop/PlayerUpgrades/Abilities/FlamingSkull/VBoxContainer/SDLabel.text = "Skull Damage: +" + str(game_controller.max_skull_dam_n)
		$Shop/PlayerUpgrades/Abilities/FlamingSkull/VBoxContainer/HBoxContainer/SDCost.text = str(new_cost)
		game_controller.updage_ui()
		



func _on_SKHup_pressed():
	var cost = 100+ game_controller.max_skelly_health_n*smh_cost
	if cost <= game_controller.currency:
		game_controller.currency -= cost
		game_controller.max_skelly_health_n += 1
		game_controller.max_skelly_health_c += 1
		game_controller.max_skelly_health_v += pl_health_inc
		var new_cost = cost + smh_cost
		$Shop/SkellyUpgrades/Abilities/Health/VBoxContainer/SKHLabel.text = "Max Health: " + str(game_controller.max_skelly_health_v)
		$Shop/SkellyUpgrades/Abilities/Health/VBoxContainer/HBoxContainer/SKHCost.text = str(new_cost)
		game_controller.updage_ui()


func _on_SKHDown_pressed():
	if game_controller.max_skelly_health_n > game_controller.max_skelly_health_o:
		var cost = 100+ (game_controller.max_skelly_health_n-1)*smh_cost
		game_controller.currency += cost
		game_controller.max_skelly_health_n -= 1 
		game_controller.max_skelly_health_c -= 1 
		game_controller.max_skelly_health_v -=pl_health_inc
		$Shop/SkellyUpgrades/Abilities/Health/VBoxContainer/SKHLabel.text = "Max Health: " + str(game_controller.max_skelly_health_v)
		$Shop/SkellyUpgrades/Abilities/Health/VBoxContainer/HBoxContainer/SKHCost.text = str(cost)
		game_controller.updage_ui()


func _on_DamageUp_pressed():
	var cost = 100+ game_controller.max_skelly_damage_n*skell_damage_cost
	if cost <= game_controller.currency:
		game_controller.currency -= cost
		game_controller.max_skelly_damage_n += 1
		game_controller.max_skelly_damage_c += 1
		game_controller.max_skelly_damage_v += sk_dmg_inc
		var new_cost = cost + skell_damage_cost
		$Shop/SkellyUpgrades/Abilities/MaxSkelly/VBoxContainer/DamageLabel.text = "Damage: +" + str(game_controller.max_skelly_damage_n)
		$Shop/SkellyUpgrades/Abilities/MaxSkelly/VBoxContainer/HBoxContainer/DamageCost.text = str(new_cost)
		game_controller.updage_ui()


func _on_DamageDown_pressed():
	if game_controller.max_skelly_damage_n > game_controller.max_skelly_damage_o:
		var cost = 100+ (game_controller.max_skelly_damage_n-1)*skell_damage_cost
		game_controller.currency += cost
		game_controller.max_skelly_damage_n -= 1 
		game_controller.max_skelly_damage_c -= 1 
		game_controller.max_skelly_damage_v -=sk_dmg_inc
		$Shop/SkellyUpgrades/Abilities/MaxSkelly/VBoxContainer/DamageLabel.text = "Damage: +" + str(game_controller.max_skelly_damage_n)
		$Shop/SkellyUpgrades/Abilities/MaxSkelly/VBoxContainer/HBoxContainer/DamageCost.text = str(cost)
		game_controller.updage_ui()


func _on_Next_Level_pressed():
	if game_controller.villagers_left <= 0:
		game_controller.level += 1
		if game_controller.level > game_controller.max_levels:
			get_tree().change_scene("res://UI/EndScreen.tscn")
			game_controller.close_shop()
			
		else:
			game_controller.current_skelly = 0
			game_controller.currency_stored = game_controller.currency
			var lvl_str = "res://Levels/Lvl" + str(game_controller.level) + ".tscn"
			get_tree().change_scene(lvl_str)
			game_controller.close_shop()
			game_controller.updage_ui()
