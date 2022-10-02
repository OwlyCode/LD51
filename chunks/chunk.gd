extends Node2D

var speed = 200

func _process(delta):
	var cm = get_parent().get_parent()

	if cm.can_scroll():
		position += Vector2.LEFT * delta * speed * cm.speed_modifier

func _physics_process(delta):
	if global_position.x < -1000:
		queue_free()
