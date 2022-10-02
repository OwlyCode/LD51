extends Node2D

var asteroid = preload("res://effects/asteroid.tscn")
var asteroids_enabled = false

const ASTEROID_DENSITY = 1

var delay = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func generate():
	var a = asteroid.instantiate()
	%ChunkManager.last_chunk.add_child(a)
	a.global_position = global_position + Vector2(randf_range(-100, 50), 0)


func fill():
	var asteroids = get_tree().get_nodes_in_group("asteroids")

	if len(asteroids) < ASTEROID_DENSITY:
		generate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delay -= delta

	if delay < 0:
		delay = 1.0
		if asteroids_enabled:
			fill()
