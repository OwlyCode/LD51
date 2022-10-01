extends Camera2D

@onready var player = get_node("/root/Node2d/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	global_position = Vector2(0, player.global_position.y)
