extends Area2D

var kill = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if kill:
		kill.die("you got impaled")


func _on_area_2d_body_entered(body):
	if body.has_method("die"):
		kill = body
