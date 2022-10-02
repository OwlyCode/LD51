extends Node2D

var explosion = preload("res://effects/explosion.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if position.y > 100:
		queue_free()

	position += Vector2(-100, 150) * delta

	if $RayCast2d.is_colliding():
		self.collide($RayCast2d.get_collider())

	for x in $Area2d.get_overlapping_bodies():
		self.collide(x)

func collide(collider):
	var exp = explosion.instantiate()

	if collider.has_method("die"):
		collider.die("an asteroid obliterated you")
		get_tree().root.add_child(exp)
	else:
		collider.add_child(exp)

	exp.global_position = global_position
	queue_free()
