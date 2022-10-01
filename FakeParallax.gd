extends Node2D

var speed = 40

func _process(delta):
	if get_parent().get_parent().can_scroll():
		position += Vector2.LEFT * delta * speed

func _physics_process(delta):
	if global_position.x < -300:
		queue_free()
