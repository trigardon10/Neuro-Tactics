extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _unhandled_input(event: InputEvent) -> void:
	if visible:
		get_viewport().set_input_as_handled()
