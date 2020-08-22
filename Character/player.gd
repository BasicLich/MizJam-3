extends KinematicBody2D

onready var NavScriptNode  = get_node("../..")

export (float) var max_health = 100.0
export (float) var speed = 50.0

var path : = PoolVector2Array() setget set_path
var is_selected : bool = false

var velocity = Vector2()
var old_position
var collision

onready var health = max_health


var is_gathering : bool = false

func _ready():
	game_controller.player = self
	game_controller.connect("resource_selected",self,"_gathering")
	NavScriptNode.connect("path_requested", self, "_get_path")
	

func _input(event):
	if is_selected:
		$HealthBar.show()
	else:
		$HealthBar.hide()
	if event.is_action_pressed('right_click') and is_selected:
		is_gathering = false
		_get_path()
		$AnimatedSprite.play("Run")
	elif event.is_action_pressed("stop_move") and is_selected:
		$AnimatedSprite.play("Idle")
		path = []


func _physics_process(delta):
	var direction = Vector2()
	var starting_point = position
#	if path.size() <= 0:
#		is_gathering = false
	for i in range(path.size()):
		var distance_to_next = starting_point.distance_to(path[0])
		if distance_to_next > 1.0:
			$AnimatedSprite.play("Run")
			direction = path[0] - starting_point
			direction = direction.normalized()
			if direction.x >= 0.0:
				$AnimatedSprite.flip_h = false
			else:
				$AnimatedSprite.flip_h = true
				
			move_and_slide(direction*speed)
			break
		elif distance_to_next <= 1.0 :
			path.remove(0)
			set_process(false)
			if path.size() == 0:
				$AnimatedSprite.play("Idle")
			break	
		starting_point = path[0]


func _gathering():
	is_gathering = true


func _get_path():
	if is_selected:
		path = NavScriptNode.request_path(self.global_position, get_global_mouse_position())

func set_path(value : PoolVector2Array):
	is_gathering = true
	path = value
	if value.size() == 0: 
		return
	set_process(true)
	
func _on_PathingTimer_timeout():
	if path.size() ==1:
		if position.distance_squared_to(old_position) < 300:
				$AnimatedSprite.play("Idle")
				$Aggro/AggroCollider.disabled = false
				path = []
		old_position = position


func take_damage(damage : float):
	health -= damage
	$HealthBar.value = (health/max_health)*100

	if health <= 0.0:
		_die()


func _die():
	queue_free()



func _on_PathTimer_timeout():
	pass # Replace with function body.
