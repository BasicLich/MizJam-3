extends KinematicBody2D

onready var NavScriptNode  = get_node("../..")
onready var healthBar = $HealthBar


export (float) var base_speed = 50.0
export (float) var base_damage = 10.0
export (float) var MaxHealth = 100

var path : = PoolVector2Array() setget set_path

onready var old_position : Vector2 = self.position
onready var health = MaxHealth

var is_selected : bool = false
var is_attacking : bool = false

var velocity = Vector2()
var collision

var target
var target_wr

var is_gathering : bool = false

func _ready():
	NavScriptNode.connect("path_requested", self, "_get_path")
	game_controller.connect("enemy_clicked", self, "_set_clicked_target")


func _input(event):
	if is_selected:
		$HealthBar.show()
	else:
		$HealthBar.hide()
	if event.is_action_pressed('right_click') and is_selected:
		$Aggro/AggroCollider.disabled = true
		is_gathering = false
		_stop_chase()
		if is_attacking:
			_reset_attack()
		$AnimatedSprite.play("Run")
	elif event.is_action_pressed("stop_move") and is_selected:
		$Aggro/AggroCollider.disabled = false
		if is_instance_valid(target):
			if global_position.distance_squared_to(target.global_position) <= 400 and not is_attacking:
				is_attacking = true
				$AnimatedSprite.play("Attack")
				$AnimatedSprite.connect("animation_finished", self, "_reset_attack")
		path = []
		
	


func _physics_process(delta):
	if not is_attacking:
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
					
				move_and_slide(direction*base_speed)
				break
			elif distance_to_next <= 1.0 :
				path.remove(0)
				if path.size() == 0:
					$AnimatedSprite.play("Idle")
					$Aggro/AggroCollider.disabled = false
				set_process(false)
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



func _on_Aggro_body_entered(body):
	if body.is_in_group("Hostile"):
		target = body
		target_wr = weakref(target)
		_chase_target(target)
		$AggroTimer.start()


func _on_AggroTimer_timeout():
	_chase_target(target)


func _chase_target(_target):
	if (target_wr.get_ref()):
		path = NavScriptNode.request_path(self.global_position, _target.global_position)
		if global_position.distance_squared_to(_target.global_position) <= 400 and not is_attacking:
			is_attacking = true
			$AnimatedSprite.play("Attack")
			$AnimatedSprite.connect("animation_finished", self, "_reset_attack")

func _set_clicked_target():
	target = game_controller.ClickedEnemy
	target_wr = weakref(target)
	$AggroTimer.start()

func _stop_chase():
	$AggroTimer.stop()
	target = null


func _reset_attack():
	if target != null and target.has_method("take_damage"):
		target.take_damage(base_damage)
	is_attacking = false
	$AnimatedSprite.disconnect("animation_finished", self, "_reset_attack")
	$AnimatedSprite.play("Idle")

func _on_Aggro_body_exited(body):
	if body == target:
		_stop_chase()


func _on_PathingTimer_timeout():
	if path.size() ==1 and not is_attacking:
		if position.distance_squared_to(old_position) < 100:
				$AnimatedSprite.play("Idle")
				$Aggro/AggroCollider.disabled = false
				path = []
		old_position = position


func take_damage(damage : float):
	health -= damage
	healthBar.value = (health/MaxHealth)*100

	if health <= 0.0:
		_die()

func _die():
	game_controller.current_skelly -= 1
	game_controller.updage_ui()
	queue_free()

func raise():
	$AnimationPlayer.play("Raise")


func return_to_grave():
	game_controller.currency += int((health/MaxHealth) *100)
	_die()

