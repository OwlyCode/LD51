extends Node2D

var speed = 120

var invisible_cooldown = 0.3

var was_alive = false

func _process(delta):
	position += Vector2.LEFT * delta * speed

func _physics_process(delta):
	if not $VisibleOnScreenNotifier2d.is_on_screen() and was_alive:
		self.invisible_cooldown -= delta

		if invisible_cooldown < 0:
			queue_free()

	if $VisibleOnScreenNotifier2d.is_on_screen():
		was_alive = true
