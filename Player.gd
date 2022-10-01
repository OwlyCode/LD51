extends RigidBody2D

var alive = true

const ALIGN_CORRECTION_FORCE = 100000

var death_cause = ""

func _ready():
	lock_rotation = true
	$AnimatedSprite2d.play("Idle")

func die(death_cause):
	if alive:
		death_cause = death_cause
		%DeathPanel.visible = true
		%DeathPanel.get_node("Label").text = "You ran %d meters until %s in %s. \n\n Press X to start over." % [%ChunkManager.total_distance, death_cause, %Timer.current_dimension]
		$DeathSound.play()
		%Timer.stop()
		alive = false

func _physics_process(delta):

	if %ChunkManager.idling and (Input.is_action_pressed("right") or Input.is_action_pressed("left") or Input.is_action_pressed("jump")):
		%ChunkManager.idling = false
		%Intro.visible = false
		%Timer.start()

	if not alive and Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
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
		if %ChunkManager.idling:
			$AnimatedSprite2d.play("Idle")
			linear_damp = 100
		else:
			$AnimatedSprite2d.play("Run")
			linear_damp = 0
	else:
		$AnimatedSprite2d.play("Jump")