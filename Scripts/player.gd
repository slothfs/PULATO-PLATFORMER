extends CharacterBody2D

@export var walk_speed: float = 150.0
@export var run_speed: float = 280.0
@export var jump_force: float = -400.0
@export var gravity: float = 900.0

@onready var anim = $PlayerAnimation

var is_dead: bool = false
var step_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

var jump_snd: AudioStream
var walk_snd: AudioStream
var run_snd: AudioStream
var death_snd: AudioStream

var step_timer: float = 0.0

func _ready():
	step_player = AudioStreamPlayer.new()
	step_player.volume_db = -6.0
	add_child(step_player)
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.volume_db = -6.0
	add_child(sfx_player)
	
	if FileAccess.file_exists("res://Assets/Audio/better_jump.wav"):
		jump_snd = load("res://Assets/Audio/better_jump.wav")
	elif FileAccess.file_exists("res://Assets/Audio/jump.wav"):
		jump_snd = load("res://Assets/Audio/jump.wav")
		
	if FileAccess.file_exists("res://Assets/Audio/slime_walk_random.tres"):
		walk_snd = load("res://Assets/Audio/slime_walk_random.tres")
	if FileAccess.file_exists("res://Assets/Audio/slime_run_random.tres"):
		run_snd = load("res://Assets/Audio/slime_run_random.tres")
	if FileAccess.file_exists("res://Assets/Audio/impact_death.wav"):
		death_snd = load("res://Assets/Audio/impact_death.wav")

func die():
	if is_dead: return
	is_dead = true
	velocity = Vector2.ZERO
	anim.play("death")
	
	if death_snd:
		sfx_player.stream = death_snd
		sfx_player.play()
	
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Scenes/dead_scene.tscn")

func _input(event):
	if is_dead: return
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		anim.play("jump")
		if jump_snd:
			sfx_player.stream = jump_snd
			sfx_player.play()

func _physics_process(delta):
	if is_dead: return
	
	if global_position.y > 1000.0:
		die()
		return
		
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
			step_timer -= delta
			if step_timer <= 0:
				step_timer = 0.3
				if run_snd:
					step_player.stream = run_snd
					step_player.play()

	# RUN RIGHT (Shift + D)
	elif Input.is_action_pressed("right_run"):
		direction = 1
		velocity.x = direction * run_speed
		
		if is_on_floor():
			anim.play("run")
			step_timer -= delta
			if step_timer <= 0:
				step_timer = 0.3
				if run_snd:
					step_player.stream = run_snd
					step_player.play()

	# WALK LEFT (A)
	elif Input.is_action_pressed("left"):
		direction = -1
		velocity.x = direction * walk_speed
		
		if is_on_floor():
			anim.play("walk")
			step_timer -= delta
			if step_timer <= 0:
				step_timer = 0.4
				if walk_snd:
					step_player.stream = walk_snd
					step_player.play()

	# WALK RIGHT (D)
	elif Input.is_action_pressed("right"):
		direction = 1
		velocity.x = direction * walk_speed
		
		if is_on_floor():
			anim.play("walk")
			step_timer -= delta
			if step_timer <= 0:
				step_timer = 0.4
				if walk_snd:
					step_player.stream = walk_snd
					step_player.play()

	# IDLE
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		step_timer = 0.0 # Reset so next move plays sound immediately
		
		if is_on_floor():
			anim.play("idle")

	# Flip sprite
	if direction != 0:
		anim.flip_h = direction < 0

	# Air animation
	if not is_on_floor():
		anim.play("jump")

	move_and_slide()


func _on_next_lvl_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
