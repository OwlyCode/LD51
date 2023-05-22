extends Node2D

var chunks = [
	preload("res://chunks/flat.tscn"),
	preload("res://chunks/flat2.tscn"),
	preload("res://chunks/flat3.tscn"),
	preload("res://chunks/flat4.tscn"),
]

var possible_chunks = [
	[4.0, preload("res://chunks/flat.tscn")],
	[1.0, preload("res://chunks/flat2.tscn")],
	[1.0, preload("res://chunks/flat3.tscn")],
	[0.5, preload("res://chunks/flat4.tscn")],
]

var weighted_chunks = []
var max_chunk_dice_roll = 1.0

var parallax = [
	preload("res://parallax/parallax1.tscn"),
]

const CELL_SIZE = 16

var jump_flat = [
	Vector2(6, 0), # short
	Vector2(8, 0), # wide
	Vector2(10, 0), # very wide
]

var jump_up = [
	Vector2(4, -1), # short up
	Vector2(6, -2), # wide up
]

var jump_down = [
	Vector2(8, 1), # short down
	Vector2(10, 2), # wide down
	Vector2(12, 3), # leap down
]

@onready var player = get_node("/root/Node2d/Player")

var last_chunk = null
var last_parallax = null
var lowest = 0

var total_distance = 0.0

var idling = true

var first_chunk = true

var speed_modifier = 0.7
var jump_modifier = 0

func _ready():
	var offset = 0.0

	for x in possible_chunks:
		weighted_chunks.append([offset, x[1]])
		offset += x[0]

	weighted_chunks.reverse()
	self.max_chunk_dice_roll = offset


func _process(delta):
	refresh_lowest()
	fill()
	fill_parallax()

	if player.global_position.y > lowest + 200 and player.alive:
		player.die("you fell from a very high place")

	if can_scroll():
		total_distance += 6.0 * delta
		%DistanceDisplay.text = "%dm" % total_distance

func roll_chunk():
	var roll = randf_range(0.0, max_chunk_dice_roll)

	for x in weighted_chunks:
		if x[0] < roll:
			return x[1]

	return null

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
		var lw = child.global_position.y + 80

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
	var prefab

	if first_chunk:
		first_chunk = false
		prefab = preload("res://chunks/flat.tscn")
	else:
		prefab = roll_chunk()

	var instance = prefab.instantiate()


	var jump_sizes = jump_flat

	if last_chunk and (last_chunk.get_node("Entry").global_position.y > 0):
		jump_sizes = jump_up
	elif last_chunk and (last_chunk.get_node("Entry").global_position.y < -24):
		jump_sizes = jump_down
	else:
		jump_sizes = jump_flat + jump_up + jump_down

	var rand_index = randi() % jump_sizes.size()
	var jump_size = jump_sizes[rand_index]

	if last_chunk:
		instance.global_position = last_chunk.get_node("Exit").global_position - instance.get_node("Entry").position + jump_size * CELL_SIZE + Vector2(jump_modifier * CELL_SIZE, 0)

	$Chunks.add_child(instance)

	last_chunk = instance
