extends Node2D

export var damage : int = 50

var color : Color = Color(0.85, 0.3, 0.3, 0.5)

onready var timer = $Timer

var max_radius : float = 35.0
var radius : float = 1.0
var targets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	radius = (timer.wait_time - timer.time_left)/ timer.wait_time * max_radius
	update()

func _draw():
	draw_circle($Location.position, radius, color )


func _on_Timer_timeout():
	$CPUParticles2D.emitting = true
	for target in targets:
		target.take_damage(damage)
	
	$DestroyTimer.start()


func _on_Area2D_body_entered(body):
	if body.is_in_group("Friendly"):
		targets.append(body)



func _on_Area2D_body_exited(body):
	if body.is_in_group("Friendly"):
		targets.erase(body)


func _on_DestroyTimer_timeout():
	queue_free()
