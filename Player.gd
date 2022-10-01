extends RigidBody2D

const ALIGN_CORRECTION_FORCE = 100000

func _ready():
	lock_rotation = true

func _process(delta):
	if not $VisibleOnScreenNotifier2d.is_on_screen():
		get_tree().reload_current_scene()

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		set_axis_velocity(Vector2.RIGHT * 150)
	elif Input.is_action_pressed("left"):
		set_axis_velocity(Vector2.LEFT * 150)
	else:
		set_axis_velocity(Vector2.RIGHT)

	if Input.is_action_just_pressed("jump"):
		if $LeftGroundChecker.is_colliding() or $RightGroundChecker.is_colliding():
			apply_central_impulse(Vector2.UP * 20000)
