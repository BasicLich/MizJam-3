extends Control

onready var grave_area = preload("res://GraveArea.tscn")

var dialog = [ "Hey Welcome! First day as a necromancer? I'm here to show you the ropes. Press [enter] if you're listenin'",
	"Good stuff. Let's first make sure you can walk.",
	"Go 'head and [left-click] and [drag] to select yourself. You'll know you've done it if you see a lil' heart over your head. Then [right-click] where you wanna go.",
	"Great job! See that villager to your right? Hover your mouse over him and press [Q]. Careful this uses some of your health!",
	"You can't cast too often! Once your color returns to normal, you may cast again!",
	"Once dead, bones are left behind. Get close enough and press [R] to raise your first Skelly of many!",
	"Where did it get that spear you ask?",
	"Listen, friend... this whole process is gunna be a lot easier for the both of us if you just.... dont think about things much.",
	"You can select and move your skellys just like you move yourself.",
	"Press [Shift] while they are selected if you want to stop their movement. If stopped, they will attack those in range.",
	"They will try to attack on their own, but good skelly pathing is hard...",
	"Your goal is to send as many skellys to the graveyard as possible.",
	"Why? Well our necromantic powers are stronger when graveyards are full... remember when I said not to think too hard? Internalize that.",
	"You can move the camera with [W],[A],[S], and [D] and [Scroll] the mouse to zoom in/out.",
	"If you want, pressing the number [1] will select you and deselect all your skellys. [2] does the opposite.",
	"The top right shows how many villagers there are, bottom right is how many skellys you have, and top left is your health.",
	"Send Skellys to the graveyard to increase your Necromantic Points (shown in bottom left). ",
	"Once you clear all the villagers in the current village, you can move onto the next one!",
	"Go to the graveyard yourself to spend your points and go to the next village whenever you are ready!",
	"Friendly tip, retreat your low health skellys; they are worth no points if destroyed!",
	"Press [Tab] to open the menu to restart the level or turn off music.",
	"Good Luck! Move into the graveyard to go to the next village!"
]

var dialog_index = 0
onready var NavScriptNode  = get_node("../..")
var finished = false
var one_completed = false
var two_completed = false
var three_completed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	MOUSE_FILTER_IGNORE
	load_dialog()
	NavScriptNode.connect("path_requested", self, "_step_one")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Indicator.visible = finished
	if Input.is_action_just_pressed("ui_accept") and finished:
		load_dialog()
	if Input.is_action_just_pressed("ability_1") and finished and dialog_index == 4:
		_step_two()
	if Input.is_action_just_pressed("raise") and game_controller.current_skelly >0:
		_step_three()
func load_dialog():
	if dialog_index < dialog.size()-1:
		$RichTextLabel.text = dialog[dialog_index]
		$RichTextLabel.percent_visible = 0
		$Tween.interpolate_property(
			$RichTextLabel, "percent_visible", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
		finished = false
		$AnimatedSprite.play("Talking")
		if dialog_index <=2:
			dialog_index += 1
		elif dialog_index <4:
			if not one_completed:
				hide()
			else:
				dialog_index += 1
		elif dialog_index ==4: 
			if not two_completed:
				hide()
			else:
				dialog_index +=1
		elif dialog_index == 6:
			if game_controller.current_skelly ==0:
				hide()
			else:
				dialog_index +=1
		else:
			dialog_index +=1
				
	else:
		var garea = grave_area.instance()
		garea.position = Vector2(260, -145)
		garea.scale.x = 3.0
		garea.scale.y = 1.5
		get_parent().get_parent().add_child(garea)
		queue_free()
	print(dialog_index)


func _on_Tween_tween_completed(object, key):
	finished = true
	$AnimatedSprite.play("Done")


func _step_one():
	if dialog_index ==3 or dialog_index == 2 :
		one_completed = true
		dialog_index=3
		load_dialog()
		show()


func _step_two():
	dialog_index=4
	two_completed = true
	load_dialog()
	show()
	
func _step_three():
	dialog_index = 6
	load_dialog()
	show()
