extends RigidBody2D

var alive = true

var death_cause = ""

func _ready():
	lock_rotation = true
	$AnimatedSprite2d.play("Idle")

func die(death_cause):
	if alive:
		$AnimatedSprite2d.play("Die")
		death_cause = death_cause
		$DeathSound.play()
		%Timer.paused = true
		alive = false
		$CollisionShape2d.disabled = true
		lock_rotation = false
		apply_central_impulse(Vector2(25000, -25000))

		get_tree().create_timer(1.0).connect("timeout", Callable(self, "death_panel_show"))

func death_panel_show():
		%DeathPanel.visible = true
		%DeathPanel.get_node("Label").text = "You ran %d meters until %s in %s. \n\n Press X to start over." % [%ChunkManager.total_distance, death_cause, %Timer.current_dimension]


func _physics_process(delta):
	if not alive and Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()

	if not alive:
		$AnimatedSprite2d.rotation += delta * 20
		return

	if $LeftPressureChecker.is_colliding() and $RightPressureChecker.is_colliding():
		die("you got squished to death")

	if %ChunkManager.idling and (Input.is_action_pressed("right") or Input.is_action_pressed("left") or Input.is_action_pressed("jump")):
		%ChunkManager.idling = false
		%Intro.visible = false
		%Timer.paused = false

	if alive and Input.is_action_pressed("right"):
		set_axis_velocity(Vector2.RIGHT * 150)
	elif alive and Input.is_action_pressed("left"):
		set_axis_velocity(Vector2.LEFT * 150)
	elif alive:
		set_axis_velocity(Vector2.RIGHT)

	if alive and Input.is_action_just_pressed("jump"):
		if $LeftGroundChecker.is_colliding() or $RightGroundChecker.is_colliding():
			apply_central_impulse(Vector2.UP * 25000)
			$JumpSound.play()

	if $LeftGroundChecker.is_colliding() or $RightGroundChecker.is_colliding():
		if %ChunkManager.idling:
			$AnimatedSprite2d.play("Idle")
			linear_damp = 100
		elif alive:
			$AnimatedSprite2d.play("Run")
			linear_damp = 0
	else:
		$AnimatedSprite2d.play("Jump")
