extends Area2D
class_name Portal

@export var target_level: PackedScene
@export var pull_speed: float = 200.0
@export var rotate_speed: float = 5.0

@onready var pull_area: Area2D = $PullArea
@onready var teleport_area: Area2D = $TeleportArea

var player: CharacterBody2D = null
var teleporting: bool = false

func _ready() -> void:
	if pull_area:
		pull_area.body_entered.connect(_on_pull_entered)
		pull_area.body_exited.connect(_on_pull_exited)
	if teleport_area:
		teleport_area.body_entered.connect(_on_teleport_entered)

func _physics_process(delta: float) -> void:
	if player and is_instance_valid(player) and not teleporting:
		var dir: Vector2 = (global_position - player.global_position).normalized()
		
		# Move them towards the portal's center
		player.global_position += dir * pull_speed * delta
		player.rotation += rotate_speed * delta
		
		# Zero out their velocity so player's move_and_slide doesn't fight the pull
		player.velocity = Vector2.ZERO

func _on_pull_entered(body: Node2D) -> void:
	if (body.name == "Player" or body.is_in_group("player")) and body is CharacterBody2D:
		player = body
		player.set_physics_process(false)

func _on_pull_exited(body: Node2D) -> void:
	if body == player:
		player = null
		if is_instance_valid(body) and body is CharacterBody2D:
			body.rotation = 0
			body.set_physics_process(true)

func _on_teleport_entered(body: Node2D) -> void:
	if (body.name == "Player" or body.is_in_group("player")) and not teleporting:
		teleporting = true
		if target_level:
			var transition = get_node("/root/SceneTransition")
			if transition:
				transition.change_scene(target_level.resource_path)
			else:
				get_tree().change_scene_to_file(target_level.resource_path)
		else:
			print("No target level set for portal!")
