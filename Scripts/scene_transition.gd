extends CanvasLayer

@onready var top_rect: ColorRect = $TopRect
@onready var bottom_rect: ColorRect = $BottomRect

func _ready() -> void:
	top_rect.anchor_bottom = 0.0
	bottom_rect.anchor_top = 1.0

func change_scene(target_path: String) -> void:
	get_tree().paused = true
	
	var tween: Tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_parallel(true)
	tween.tween_property(top_rect, "anchor_bottom", 0.5, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(bottom_rect, "anchor_top", 0.5, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	
	get_tree().paused = false
	get_tree().change_scene_to_file(target_path)
	
	var tween_out: Tween = create_tween()
	tween_out.set_parallel(true)
	tween_out.tween_property(top_rect, "anchor_bottom", 0.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween_out.tween_property(bottom_rect, "anchor_top", 1.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
