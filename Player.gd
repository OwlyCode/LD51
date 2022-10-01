extends RigidBody2D

const ALIGN_CORRECTION_FORCE = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	lock_rotation = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if position.x < 0:
		constant_force = Vector2.RIGHT * ALIGN_CORRECTION_FORCE
	elif position.x > 0:
		constant_force = Vector2.LEFT * ALIGN_CORRECTION_FORCE
	else:
		constant_force = Vector2.ZERO

	if Input.is_action_just_pressed("jump"):
		if $LeftGroundChecker.is_colliding() or $RightGroundChecker.is_colliding():
			apply_central_impulse(Vector2.UP * 20000)
