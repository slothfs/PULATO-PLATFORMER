extends Control

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/levels/level_1.tscn")
