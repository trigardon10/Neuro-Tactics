extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Title/VSplitContainer2/VSplitContainer2/CenterContainer/Start.grab_focus()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Map1/Map1.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
