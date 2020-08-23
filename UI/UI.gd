extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var currency_label = $HBoxContainer2/CurrencyLabel
onready var villager_label = $VBoxContainer/HBoxContainer/Villager_Label
onready var skelly_label = $VBoxContainer2/HBoxContainer/SkellyLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	game_controller.UI = self
	game_controller.connect("update_ui", self, "_update_ui")
	_update_ui()

func set_health():
	$HBoxContainer/HealthBar.value = game_controller.player_health


func _update_ui():
	skelly_label.text = str(game_controller.current_skelly) + "/" + str(game_controller.max_skelly)
	villager_label.text = str(game_controller.villagers_left) + "/" + str(game_controller.total_villagers)
	currency_label.text = str(game_controller.currency)
