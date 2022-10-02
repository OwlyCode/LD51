extends Node2D

var desired_offset = -80.0

enum Status {
	AIMING,
	IDLING,
	LOCKING,
}

const AIMING_TIME = 2.0
const IDLING_TIME = 1.0
const LOCKING_TIME = 1.0

var timer = IDLING_TIME
var status = Status.IDLING

@onready var player = get_node("/root/Node2d/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (global_position.y != player.global_position.y + desired_offset) and player.alive:
		global_position.y = lerp(global_position.y, player.global_position.y + desired_offset, delta)

	var raycast = $Gun.get_node("RayCast2d")
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

	if status == Status.AIMING and timer < 0:
		status = Status.LOCKING
		timer = LOCKING_TIME
		line.visible = true

	if status == Status.LOCKING and timer < 0:
		status = Status.IDLING
		timer = IDLING_TIME
		line.visible = false
