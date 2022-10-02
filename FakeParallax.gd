extends Node2D

var speed = 40

func _process(delta):
	var cm = get_parent().get_parent()

	if cm.can_scroll():
		position += Vector2.LEFT * delta * speed * cm.speed_modifier

func _physics_process(delta):
	if global_position.x < -400:
		queue_free()
