extends Timer

# Effects
# Skew
# Rotate ?
# Flip ?

# Voice Singing dimension
# Falling guys dimension

# Kinds of modifiers : graphics, gameplay, tileset (can be cumulative)

var rift1 = preload("res://arts/space1.png")
var rift2 = preload("res://arts/space2.png")
var rift3 = preload("res://arts/space3.png")

var current_dimension = "the normal dimension"

@onready var game_sequence = [
	# [Callable(grayscale)],
	# [Callable(noop)],
	# [Callable(crt)],
	# [Callable(asteroids)],
	# [Callable(noop)],
	# [Callable(crt), Callable(asteroids)],
]

@onready var camera = get_node("/root/Node2d/Camera2d")

func _ready():
	reset_visual_effect()

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
		var applied_visual_effect = rand_visual_effect()
		var applied_game_effect = rand_game_effect()

		current_effects = []
		current_effects.append(applied_visual_effect)
		current_effects.append(applied_game_effect)

	$EventEffect.play()
	buildup_played = false


var current_effects = []

func rand_visual_effect():
	var funcs = [Callable(grayscale), Callable(hex), Callable(crt), Callable(noop)]

	var rand_index = randi() % funcs.size()
	var fn = funcs[rand_index]

	if fn in current_effects:
		return rand_visual_effect()

	fn.call()

	return fn

func rand_game_effect():
	var funcs = [Callable(asteroids), Callable(noop)]

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
	current_dimension = "the grayscale dimension"

func hex():
	%ScreenShader.material.shader = preload("res://shaders/hex.gdshader")
	current_dimension = "the HEX dimension"

func crt():
	%ScreenShader.material.shader = preload("res://shaders/crt.gdshader")
	current_dimension = "the CRT dimension"

func reset_visual_effect():
	%ScreenShader.material.shader = preload("res://shaders/noop.gdshader")
	current_dimension = "the normal dimension"

func asteroids():
	%AsteroidSpawner.asteroids_enabled = true

func reset_game_effects():
	%AsteroidSpawner.asteroids_enabled = false
