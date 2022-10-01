extends Node2D

var chunks = [
	preload("res://chunks/flat.tscn"),
	preload("res://chunks/flat2.tscn"),
	preload("res://chunks/flat3.tscn"),
]

var last_chunk = null
var lowest = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	refresh_lowest()
	fill()

func fill():
	if get_child_count() < 8:
		spawn_next()

func refresh_lowest():
	lowest = INF
	for child in get_children():
		var lw = child.get_node("Lowest").global_position.y

		if lw < lowest:
			lowest = lw

func spawn_next():
	var rand_index:int = randi() % chunks.size()

	var instance = chunks[rand_index].instantiate()

	var jump_size = Vector2.RIGHT * 16

	if last_chunk:
		instance.global_position = last_chunk.get_node("Exit").global_position - instance.get_node("Entry").position + jump_size

	add_child(instance)

	last_chunk = instance
