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

var jump_flat = [
	Vector2(3, 0), # short
	Vector2(4, 0), # wide
	Vector2(5, 0), # very wide
]

var jump_up = [
	Vector2(3, -1), # short up
	Vector2(3, -2), # wide up
]

var jump_down = [
	Vector2(3, 1), # short down
	Vector2(3, 2), # wide down
	Vector2(3, 3), # leap down
]

@onready var player = get_node("/root/Node2d/Player")

var last_chunk = null
var last_parallax = null
var lowest = 0

var total_distance = 0.0

var idling = true

var first_chunk = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	refresh_lowest()
	fill()
	fill_parallax()

	if player.global_position.y > lowest + 200:
		player.die("you fell from a very high place")

	if can_scroll():
		total_distance += 6.0 * delta
		%DistanceDisplay.text = "%dm" % total_distance

func can_scroll():
	return player.alive and not idling

func fill():
	if $Chunks.get_child_count() < 4:
		spawn_next()

func fill_parallax():
	if $FakeParallax.get_child_count() < 3:
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
	$FakeParallax.add_child(instance)

	if last_parallax:
		instance.global_position = last_parallax.global_position + Vector2(255, 0)


	last_parallax = instance



func spawn_next():
	var rand_index:int = randi() % chunks.size()

	if first_chunk:
		rand_index = 0
		first_chunk = false

	var instance = chunks[rand_index].instantiate()


	var jump_sizes = jump_flat

	if last_chunk and (last_chunk.get_node("Entry").global_position.y > 0):
		jump_sizes = jump_up
	elif last_chunk and (last_chunk.get_node("Entry").global_position.y < -24):
		jump_sizes = jump_down
	else:
		jump_sizes = jump_flat + jump_up + jump_down

	rand_index = randi() % jump_sizes.size()
	var jump_size = jump_sizes[rand_index]

	if last_chunk:
		instance.global_position = last_chunk.get_node("Exit").global_position - instance.get_node("Entry").position + jump_size * CELL_SIZE

	$Chunks.add_child(instance)

	last_chunk = instance
