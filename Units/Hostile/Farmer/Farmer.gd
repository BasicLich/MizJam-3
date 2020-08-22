extends KinematicBody2D

export (float) var BaseSpeed = 20.0
export var MaxHealth : float = 1000
export var base_damage : float = 20

onready var health : float = MaxHealth
onready var speed : float = BaseSpeed

onready var Bone = preload("res://Units/Hostile/Bones/bones.tscn")

onready var healthBar = $HealthBar

var targetList = []

onready var NavScriptNode  = get_node("../..")

var is_aggroed : bool = false
var has_moved : bool = false #This is used to move back and forth (just to make seem more alive)
var is_attacking : bool = false

var target = null
var target_wr

var path : = PoolVector2Array() setget set_path
var is_selected : bool = false

var velocity = Vector2()
var collision

var is_gathering : bool = false

signal enemy_clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var direction = Vector2()
	var starting_point = position
#	if path.size() <= 0:
#		is_gathering = false
	for i in range(path.size()):
		var distance_to_next = starting_point.distance_to(path[0])
		if distance_to_next > 1.0:
			direction = path[0] - starting_point
			direction = direction.normalized()
			move_and_slide(direction*speed)
			break
		elif distance_to_next <= 1.0 :
			path.remove(0)
			set_process(false)
			break	
		starting_point = path[0]


func take_damage(damage : float):
	health -= damage
	healthBar.value = (health/MaxHealth)*100

	if health <= 0.0:
		$AnimationPlayer.play("Die")
		


func _get_path():
	if is_selected:
		path = NavScriptNode.request_path(self.global_position, get_global_mouse_position())

func set_path(value : PoolVector2Array):
	is_gathering = true
	path = value
	if value.size() == 0: 
		return
	set_process(true)

func _die():
	var bone_spawn = Bone.instance()
	bone_spawn.position = position
	get_parent().add_child(bone_spawn)
	
	queue_free()

func _on_FearRange_body_entered(body):
	if body.is_in_group("Friendly"):
		print("target gained")
		targetList.append(body)
		print(targetList)
		if target == null:
			target = body
			$FearRange/CollisionShape2D.scale.x = 0.5
			$FearRange/CollisionShape2D.scale.y = 0.5
			targetList = []
			targetList.append(body)
			
		target_wr = weakref(target)
		_chase_target(target)
		$AggroTimer.start()

func _on_FearRange_body_exited(body):
	if body.is_in_group("Friendly"):
		targetList.erase(body)
		if body == target and targetList.size()>0:
			target = targetList[0]
			print("EXITED")
			print(targetList)


		



func _chase_target(_target):
	if (target_wr.get_ref()):
		path = NavScriptNode.request_path(self.global_position, _target.global_position)
		if global_position.distance_squared_to(_target.global_position) <= 300 and not is_attacking:
			is_attacking = true
			$AnimatedSprite.play("Attack")
			$AnimatedSprite.connect("animation_finished", self, "_reset_attack")
	else:
		if targetList.size()>0:
			target = targetList[0]
			target_wr = weakref(target)
			_chase_target(target)

func _reset_attack():
	if target != null :
		if target.has_method("take_damage"):
			target.take_damage(base_damage)
	is_attacking = false
	$AnimatedSprite.disconnect("animation_finished", self, "_reset_attack")
	$AnimatedSprite.play("Run")


func _on_AggroTimer_timeout():
#	if targetList.size() >0:
#		var nearest_body = targetList[0]
#		if position.distance_squared_to(nearest_body.position) >= 250:
#			for body in targetList:
#				if position.distance_squared_to(nearest_body.position) < position.distance_squared_to(body.position):
#					nearest_body = body
#			target = nearest_body
		_chase_target(target) #If I uncomment in future, this may be on wrong indent
			 
		
		

func _on_PathTimer_timeout():
	if not is_aggroed:
		var run_location= global_position
		if has_moved:
			run_location.x += 20
			run_location.y += 30
			path = NavScriptNode.request_path(self.global_position, run_location)
			has_moved = false
		else:
			run_location.x -= 20
			run_location.y -= 30
			path = NavScriptNode.request_path(self.global_position, run_location)
			has_moved = true




func _on_Farmer_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_RIGHT:
				emit_signal("enemy_clicked")




func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Die":
		_die()
