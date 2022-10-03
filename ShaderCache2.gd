extends CanvasLayer

var count_down = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if count_down > 0:
		count_down -= 1
	else:
		visible = false
