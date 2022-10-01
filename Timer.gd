extends Timer

# Effects
# Skew
# Rotate ?
# Flip ?

# Kinds of modifiers : graphics, gameplay, tileset (can be cumulative)

var rift1 = preload("res://arts/space1.png")
var rift2 = preload("res://arts/space2.png")
var rift3 = preload("res://arts/space3.png")

@onready var camera = get_node("/root/Node2d/Camera2d")

func _ready():
	pass

const MAX_BLINK_SPEED = 0.125
const MIN_BLINK_SPEED = 0.025

var blink = MAX_BLINK_SPEED
var buildup_played = false

func _process(delta):

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
		%Glow.modulate = Color(1.0, 0.0, 0.0, lerp(0.25, 0.0, time_left / 2))
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
	%ScreenShader.material.shader = preload("res://shaders/grayscale.gdshader")
	$EventEffect.play()
	buildup_played = false
