extends Area2D

@export var next_scene: String = "res://Scenes/levels/level_2.tscn"

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if next_scene != "":
			get_tree().change_scene_to_file("res://Scenes/levels/level_3.tscn")
