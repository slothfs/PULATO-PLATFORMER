extends CharacterBody2D

@export var walk_speed: float = 150.0
@export var run_speed: float = 280.0
@export var jump_force: float = -400.0
@export var gravity: float = 900.0

@onready var anim = $PlayerAnimation


func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = 0

	# RUN LEFT (Shift + A)
	if Input.is_action_pressed("left_run"):
		direction = -1
		velocity.x = direction * run_speed
		
		if is_on_floor():
			anim.play("run")

	# RUN RIGHT (Shift + D)
	elif Input.is_action_pressed("right_run"):
		direction = 1
		velocity.x = direction * run_speed
		
		if is_on_floor():
			anim.play("run")

	# WALK LEFT (A)
	elif Input.is_action_pressed("left"):
		direction = -1
		velocity.x = direction * walk_speed
		
		if is_on_floor():
			anim.play("walk")

	# WALK RIGHT (D)
	elif Input.is_action_pressed("right"):
		direction = 1
		velocity.x = direction * walk_speed
		
		if is_on_floor():
			anim.play("walk")

	# IDLE
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		
		if is_on_floor():
			anim.play("idle")

	# Flip sprite
	if direction != 0:
		anim.flip_h = direction < 0

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		anim.play("jump")

	# Air animation
	if not is_on_floor():
		anim.play("jump")

	move_and_slide()
