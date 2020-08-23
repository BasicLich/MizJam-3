extends KinematicBody2D

export (float) var BaseSpeed = 20.0
export var MaxHealth : float = 25

onready var health : float = MaxHealth
onready var speed : float = BaseSpeed

onready var healthBar = $HealthBar

onready var NavScriptNode  = get_node("../..")

var is_feared : bool = false
var is_fighter : bool = false
var has_moved : bool = false #This is used to move back and forth (just to make seem more alive)


var path : = PoolVector2Array() setget set_path
var is_selected : bool = false

var velocity = Vector2()
var collision

var is_gathering : bool = false
var rng = RandomNumberGenerator.new()

var patrol_distance = Vector2()

onready var Bone = preload("res://Units/Hostile/Bones/bones.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	patrol_distance.x = rng.randf_range(25,100)
	patrol_distance.y = rng.randf_range(5,25)
	$AggroTimer.wait_time = rng.randf_range(3,6)

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
	
	game_controller.villagers_left -= 1
	game_controller.updage_ui()
	queue_free()

func _on_FearRange_body_entered(body):
	if not body.is_in_group("Hostile"):
		if not is_fighter:
			is_feared = true
			var run_location = global_position
			if position.direction_to(body.position).x >0.0 :
				run_location.x -=300
			else:
				run_location.x += 300
			
			path = NavScriptNode.request_path(self.global_position, run_location)


func _on_AggroTimer_timeout():
	if not is_feared:
		var run_location= global_position
		if has_moved:
			run_location.x += patrol_distance.x
			run_location.y += patrol_distance.y
			path = NavScriptNode.request_path(self.global_position, run_location)
			has_moved = false
		else:
			run_location.x -= patrol_distance.x
			run_location.y -= patrol_distance.y
			path = NavScriptNode.request_path(self.global_position, run_location)
			has_moved = true
			 
		
		


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Die":
		_die()
