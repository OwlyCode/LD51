extends Node2D

var speed = 200

func _process(delta):
	position += Vector2.LEFT * delta * speed

func _physics_process(delta):
	if global_position.x < -1000:
		queue_free()
