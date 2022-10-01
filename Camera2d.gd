extends Camera2D

@onready var player = get_node("/root/Node2d/Player")
@onready var chunk_manager = get_node("/root/Node2d/ChunkManager")

func _process(delta):
	var y = player.global_position.y

	if y > chunk_manager.lowest:
		y = chunk_manager.lowest

	global_position = Vector2(0, y)
