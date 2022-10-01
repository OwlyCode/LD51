extends Node2D

var speed = 50

var invisible_cooldown = 0.3

var was_alive = false

func _process(delta):
	position += Vector2.LEFT * delta * speed

func _physics_process(delta):
	if global_position.x < -300:
		queue_free()
