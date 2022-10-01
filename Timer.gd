extends Timer

# Effects
# Skew
# Rotate ?
# Flip ?

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#%ScreenShader.material.shader = preload("res://shaders/grayscale.gdshader")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	print("lel")

	%ScreenShader.material.shader = preload("res://shaders/grayscale.gdshader")
