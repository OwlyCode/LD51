extends RigidBody2D

var alive = true

const ALIGN_CORRECTION_FORCE = 100000

func _ready():
	lock_rotation = true
	$AnimatedSprite2d.play("Run")

func die():
	if alive:
		$DeathSound.play()
		alive = false

func _on_death_sound_finished():
	get_tree().reload_current_scene()

func _physics_process(delta):
	if alive and Input.is_action_pressed("right"):
		set_axis_velocity(Vector2.RIGHT * 150)
	elif alive and Input.is_action_pressed("left"):
		set_axis_velocity(Vector2.LEFT * 150)
	else:
		set_axis_velocity(Vector2.RIGHT)

	if alive and Input.is_action_just_pressed("jump"):
		if $LeftGroundChecker.is_colliding() or $RightGroundChecker.is_colliding():
			apply_central_impulse(Vector2.UP * 25000)
			$JumpSound.play()

	if $LeftGroundChecker.is_colliding() or $RightGroundChecker.is_colliding():
		$AnimatedSprite2d.play("Run")
	else:
		$AnimatedSprite2d.play("Jump")