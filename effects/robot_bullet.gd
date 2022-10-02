extends Line2D

var explosion = preload("res://effects/explosion.tscn")

@onready var player = get_node("/root/Node2d/Player")
var target_position

func _ready():
	rotation = target_position.angle_to_point(global_position)


func _process(delta):
	var rotation_vector = Vector2.LEFT.rotated(rotation)
	position += rotation_vector * 500 * delta

	if $RayCast2d.is_colliding():
		self.collide($RayCast2d.get_collider())

	for x in $Area2d.get_overlapping_bodies():
		self.collide(x)

func collide(collider):
	var exp = explosion.instantiate()

	if collider.has_method("die"):
		collider.die("you got shot by an angry robot")
		get_tree().root.add_child(exp)
	else:
		collider.add_child(exp)

	exp.global_position = global_position
	queue_free()
