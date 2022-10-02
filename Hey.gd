extends Node2D

var desired_offset = -80.0
@onready var player = get_node("/root/Node2d/Player")

var talk_countdown = 2.0
var talked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var wr = weakref(player);
	if wr.get_ref():
		if (global_position.y != player.global_position.y + desired_offset) and player.alive:
			global_position.y = lerp(global_position.y, player.global_position.y + desired_offset, delta)

	global_position += Vector2.LEFT * delta * 50.0


	talk_countdown -= delta

	if talk_countdown < 0 and not talked:
		talk()
		talked = true

func talk():
	$AudioStreamPlayer2d.play()
	$AnimatedSprite2d.play("Talking")

func _on_audio_stream_player_2d_finished():
	$AnimatedSprite2d.play("Silent")
