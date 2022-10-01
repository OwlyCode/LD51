extends Camera2D

@onready var player = get_node("/root/Node2d/Player")
@onready var chunk_manager = get_node("/root/Node2d/ChunkManager")

var shaking = false
var shaking_amount = 0.5

func _process(delta):
	var y = player.global_position.y

	if y > chunk_manager.lowest:
		y = chunk_manager.lowest

	global_position = Vector2(0, y - 30)

	if shaking:
		set_offset(Vector2( \
			randf_range(-1.0, 1.0) * shaking_amount, \
			randf_range(-1.0, 1.0) * shaking_amount \
		))
