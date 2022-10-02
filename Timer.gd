extends Timer

var rift1 = preload("res://arts/space1.png")
var rift2 = preload("res://arts/space2.png")
var rift3 = preload("res://arts/space3.png")

var current_dimension = "the normal dimension"

var event_count = 0

@onready var game_sequence = [
	[Callable(grayscale)],
	[Callable(speed_up), Callable(increase_jump)],
	[Callable(asteroids)],
	[Callable(hex)],
	[Callable(speed_up)],
	[Callable(camera_flip_V)],
	[Callable(speed_up),Callable(color_switch)],
	[Callable(robot)],
	[Callable(speed_up)],
	[Callable(crt)],
	[Callable(asteroids), Callable(speed_up), Callable(increase_jump)],
	[Callable(robot), Callable(crt), Callable(speed_up)],
	[Callable(hey), Callable(increase_jump)]
]

@onready var camera = get_node("/root/Node2d/Camera2d")

func _ready():
	reset_visual_effect()
	reset_game_effects()

const MAX_BLINK_SPEED = 0.125
const MIN_BLINK_SPEED = 0.025

var blink = MAX_BLINK_SPEED
var buildup_played = false

func _process(delta):
	if %ChunkManager.idling:
		%Rift.visible = false
		paused = true
		return

	if time_left < 2.5 and not buildup_played:
		buildup_played = true
		$BuildUp.play()

	if time_left < 1.0:
		%Rift.visible = true
		%Rift.texture = rift3
	elif time_left < 1.5:
		%Rift.visible = true
		%Rift.texture = rift2
	elif time_left < 2.0:
		%Rift.visible = true
		%Rift.texture = rift1
	else:
		%Rift.visible = false

	if time_left < 2.0:
		camera.shaking = true
		camera.shaking_amount = lerp(3.0, 0.1, time_left / 2)
		%Glow.visible = true
		%Glow.modulate = Color(1.0, 0.0, 0.0, lerp(0.5, 0.0, time_left / 2))
	else:
		camera.shaking = false
		%Glow.modulate = Color(1.0, 0.0, 0.0, 0.0)

	if time_left < 2.0:
		%Lasers.modulate = Color.RED.lerp(Color.WHITE, time_left / 2)

		blink -= delta
		if blink < 0:
			%Lasers.visible = not %Lasers.visible
			blink = lerp(MIN_BLINK_SPEED, MAX_BLINK_SPEED, time_left / 2)
	else:
		%Lasers.visible = true
		%Lasers.modulate = Color.WHITE

func _on_timer_timeout():
	reset_visual_effect()
	reset_game_effects()

	var planned = game_sequence.pop_front()

	if planned:
		for x in planned:
			x.call()
	else:
		event_count += 1

		var applied_visual_effect = null

		if event_count % 3 == 0:
			applied_visual_effect = rand_visual_effect()

		var applied_game_effect = rand_game_effect()

		current_effects = []

		if applied_visual_effect:
			current_effects.append(applied_visual_effect)

		current_effects.append(applied_game_effect)

		if event_count % 2 == 0:
			speed_up()

		if event_count > 6:
			applied_game_effect = rand_game_effect()
			current_effects.append(applied_game_effect)

	$EventEffect.play()
	buildup_played = false


var current_effects = []

func rand_visual_effect():
	var funcs = [Callable(grayscale), Callable(hex), Callable(crt), Callable(noop), Callable(color_switch)]

	var rand_index = randi() % funcs.size()
	var fn = funcs[rand_index]

	if fn in current_effects:
		return rand_visual_effect()

	fn.call()

	return fn

func rand_game_effect():
	var funcs = [Callable(asteroids), Callable(robot), Callable(noop), Callable(camera_flip_V), Callable(camera_flip_H)]

	var rand_index = randi() % funcs.size()
	var fn = funcs[rand_index]

	if fn in current_effects:
		return rand_game_effect()

	fn.call()

	return fn

func noop():
	pass

func grayscale():
	%ScreenShader.material.shader = preload("res://shaders/grayscale.gdshader")

func hex():
	%ScreenShader.material.shader = preload("res://shaders/hex.gdshader")

func crt():
	%ScreenShader.material.shader = preload("res://shaders/crt.gdshader")

func color_switch():
	%ScreenShader.material.shader = preload("res://shaders/invert.gdshader")

func reset_visual_effect():
	%ScreenShader.material.shader = preload("res://shaders/noop.gdshader")

func asteroids():
	var parallaxes = get_tree().get_nodes_in_group("parallax")

	parallaxes.shuffle()

	parallaxes[0].get_node("Sprite2d").texture = preload("res://arts/parallax-asteroids.png")

	%AsteroidSpawner.asteroids_enabled = true

func robot():
	var robot_prefab = preload("res://effects/robot.tscn")
	var rb = robot_prefab.instantiate()
	get_tree().root.add_child(rb)
	rb.global_position = Vector2(150, 150)

func reset_game_effects():
	%Camera2d.zoom = Vector2(3, 3)

	var parallaxes = get_tree().get_nodes_in_group("parallax")

	for p in parallaxes:
		p.get_node("Sprite2d").texture = preload("res://arts/parallax1.png")

	%AsteroidSpawner.asteroids_enabled = false

	var robots = get_tree().get_nodes_in_group("robot")

	for r in robots:
		r.queue_free()

	var hey = get_tree().get_nodes_in_group("hey")

	for h in hey:
		h.queue_free()

func speed_up():
	%ChunkManager.speed_modifier += 0.1


func increase_jump():
	%ChunkManager.jump_modifier += 1


func camera_flip_V():
	%Camera2d.zoom = Vector2(3, -3)

func camera_flip_H():
	%Camera2d.zoom = Vector2(-3, 3)

func hey():
	var hey = preload("res://effects/hey.tscn")
	var h = hey.instantiate()
	get_tree().root.add_child(h)
	h.global_position = Vector2(220, 50)
