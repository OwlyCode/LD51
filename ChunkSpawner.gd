extends Node2D

var chunks = [
	preload("res://chunks/flat.tscn"),
	preload("res://chunks/flat2.tscn"),
	preload("res://chunks/flat3.tscn"),
]

var parallax = [
	preload("res://parallax/parallax1.tscn"),
]

const CELL_SIZE = 16

var jump_sizes = [
	Vector2(16, 0), # short
	Vector2(32, 0), # wide
	Vector2(48, 0), # very wide
	Vector2(16, -16), # short up
	Vector2(16, -32), # wide up
	Vector2(16, 16), # short down
	Vector2(16, 32), # wide down
	Vector2(16, 48), # leap down
]

var last_chunk = null
var last_parallax = null
var lowest = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	refresh_lowest()
	fill()
	fill_parallax()

func fill():
	if $Chunks.get_child_count() < 8:
		spawn_next()

func fill_parallax():
	if $FakeParallax.get_child_count() < 8:
		spawn_parallax()

func refresh_lowest():
	lowest = INF
	for child in $Chunks.get_children():
		var lw = child.get_node("Lowest").global_position.y

		if lw < lowest:
			lowest = lw

func spawn_parallax():
	var rand_index:int = randi() % parallax.size()
	var instance = parallax[rand_index].instantiate()
	if last_parallax:
		instance.global_position = last_parallax.global_position + Vector2(255, lowest)

	$FakeParallax.add_child(instance)

	last_parallax = instance


func spawn_next():
	var rand_index:int = randi() % chunks.size()
	var instance = chunks[rand_index].instantiate()

	rand_index = randi() % jump_sizes.size()
	var jump_size = jump_sizes[rand_index]

	if last_chunk:
		instance.global_position = last_chunk.get_node("Exit").global_position - instance.get_node("Entry").position + jump_size

	$Chunks.add_child(instance)

	last_chunk = instance
