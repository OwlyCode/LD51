extends Node2D

var desired_offset = -80.0

enum Status {
	FIRING,
	AIMING,
	IDLING,
	LOCKING,
}

const AIMING_TIME = 2.0
const IDLING_TIME = 1.0
const LOCKING_TIME = 0.1
const FIRING_TIME = 0.07

var timer = IDLING_TIME
var fire_count = 0
var status = Status.IDLING

@onready var player = get_node("/root/Node2d/Player")
@onready var raycast = $Gun.get_node("RayCast2d")

var bullet = preload("res://effects/robot_bullet.tscn")

var locked_target

# Called when the node enters the scene tree for the first time.
func _ready():
	$Gun.get_node("Line2d").visible = false


func _process(delta):
	var wr = weakref(player);
	if not wr.get_ref():
		return

	if (global_position.y != player.global_position.y + desired_offset) and player.alive:
		global_position.y = lerp(global_position.y, player.global_position.y + desired_offset, delta)

	var line = $Gun.get_node("Line2d")

	if raycast.is_colliding():
		var point = raycast.get_collision_point()

		line.points = [Vector2(0,0), line.to_local(point)]

	if status == Status.AIMING:
		$Gun.rotation = player.global_position.angle_to_point($Gun.global_position)
		timer -= delta
	else:
		timer -= delta

	if status == Status.IDLING and timer < 0:
		status = Status.AIMING
		timer = AIMING_TIME
		line.visible = true

	if status == Status.AIMING and timer < 0 and raycast.get_collider() and raycast.get_collider().has_method("die"):
		locked_target = raycast.get_collision_point()
		status = Status.LOCKING
		timer = LOCKING_TIME
		line.visible = true

	if status == Status.LOCKING and timer < 0:
		status = Status.FIRING
		timer = FIRING_TIME
		line.visible = false

	if status == Status.FIRING and timer < 0:
		if fire_count > 2:
			fire_count = 0
			status = Status.IDLING
			timer = IDLING_TIME
			line.visible = false
		else:
			timer = FIRING_TIME
			fire_count += 1
			fire()


func fire():
	var b = bullet.instantiate()
	b.target_position = locked_target
	add_child(b)
