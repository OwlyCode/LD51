extends RigidBody2D

var alive = true

var death_cause = ""

const MAX_JUMP_TOLERANCE = 0.1

var jump_tolerance = MAX_JUMP_TOLERANCE
var jumped = 0.0

func _ready():
	lock_rotation = true
	$AnimatedSprite2d.play("Idle")

func die(cause):
	if alive:
		$AnimatedSprite2d.play("Die")
		death_cause = cause
		$DeathSound.play()
		%Timer.paused = true
		alive = false
		$CollisionShape2d.disabled = true
		lock_rotation = false
		apply_central_impulse(Vector2(25000, -25000))

		get_tree().create_timer(1.0).connect("timeout", Callable(self, "death_panel_show"))

func death_panel_show():
		%DeathPanel.visible = true
		%DeathPanel.get_node("Label").text = "You ran %d meters until %s. \n\n Press X to start over." % [%ChunkManager.total_distance, death_cause]


func _process(delta):
	if not alive and Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()

	if not alive:
		return

	if %ChunkManager.idling and (Input.is_action_pressed("right") or Input.is_action_pressed("left") or Input.is_action_pressed("jump")):
		%ChunkManager.idling = false
		%Intro.visible = false
		%Timer.paused = false

	jump_tolerance -= delta
	jumped -= delta

	if $RightGroundChecker.is_colliding() and jumped < 0:
		jump_tolerance = MAX_JUMP_TOLERANCE


	if alive and Input.is_action_just_pressed("jump"):
		$LeftGroundChecker.force_raycast_update()
		$RightGroundChecker.force_raycast_update()

		if $LeftGroundChecker.is_colliding() or $RightGroundChecker.is_colliding() or jump_tolerance > 0:
			jump_tolerance = 0
			jumped = 0.5
			apply_central_impulse(Vector2.UP * 25000)
			$JumpSound.play()

func _physics_process(delta):
	if not alive:
		$AnimatedSprite2d.rotation += delta * 20
		return

	if $LeftPressureChecker.is_colliding() and $RightPressureChecker.is_colliding():
		die("you got squished to death")

	if Input.is_action_pressed("right"):
		if not $RightPressureChecker.is_colliding():
			set_axis_velocity(Vector2.RIGHT * 150)
		else:
			set_axis_velocity(Vector2.LEFT * 190 * %ChunkManager.speed_modifier)
	elif Input.is_action_pressed("left"):
		set_axis_velocity(Vector2.LEFT * (300 * %ChunkManager.speed_modifier))
	elif not %ChunkManager.idling and alive:
		if not $RightPressureChecker.is_colliding():
			set_axis_velocity(Vector2.RIGHT)
		else:
			set_axis_velocity(Vector2.LEFT * 190 * %ChunkManager.speed_modifier)

	if $LeftGroundChecker.is_colliding() or $RightGroundChecker.is_colliding():
		if %ChunkManager.idling:
			$AnimatedSprite2d.play("Idle")
			linear_damp = 0
		elif alive:
			$AnimatedSprite2d.play("Run")
			linear_damp = 0
	else:
		$AnimatedSprite2d.play("Jump")
