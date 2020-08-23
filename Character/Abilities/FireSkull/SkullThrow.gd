extends KinematicBody2D

onready var explosion_node= preload("res://Character/Abilities/FireSkull/Explosion.tscn")

# Declare member variables here. Examples:
# var a = 2
var speed = 1
var damage = 50

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(get_global_mouse_position())
	velocity = Vector2(speed, 0).rotated(rotation)
	if abs(rotation_degrees) >90:
		$AnimatedSprite.flip_v =true

func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if collision:
		if collision.get_collider().has_method("take_damage"):
			collision.get_collider().take_damage(damage)
		_die()

func _die():
	var explosion_instance = explosion_node.instance()
	explosion_instance.position = position
	get_parent().add_child(explosion_instance)
	queue_free()

func _on_Timer_timeout():
	_die()
