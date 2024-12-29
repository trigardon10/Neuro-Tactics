extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Title/VSplitContainer2/VSplitContainer2/CenterContainer/Start.grab_focus()

func _on_start_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(0,0,0,1), 0.5).set_trans(Tween.TRANS_SINE)
	await tween.finished
	get_tree().change_scene_to_file("res://src/Intro/intro.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
