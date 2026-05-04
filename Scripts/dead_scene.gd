extends Control

func _on_play_again_pressed() -> void:
	if SceneTransition.last_scene_path != "":
		get_tree().change_scene_to_file(SceneTransition.last_scene_path)
	else:
		get_tree().change_scene_to_file("res://Scenes/guide_level.tscn")
