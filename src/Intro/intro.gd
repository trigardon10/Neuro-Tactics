extends Node2D

signal pressedEnter
var blue = Color(0.2, 0.4, 1, 1)
var red = Color(0.8, 0.2, 0.2, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/MarginContainer/ColorRect.custom_minimum_size.y += 40
	showDialog("One day, Neuro-sama woke up confused. It seemed like, she lost her memories.")
	await pressedEnter
	showDialog("She soon figured out, that they were stolen by her sister Evil Neuro.")
	await pressedEnter
	showDialog("With the help of her parents Vedal and Anny, she ventured forth to confront her evil sister and get her memories back.")
	await pressedEnter
	$CanvasLayer.visible = false
	$CanvasLayer/MarginContainer/ColorRect.modulate = Color(1,1,1,1)
	$CanvasLayer/MarginContainer/ColorRect.custom_minimum_size.y -= 40
	await $FadeContainer.fade_out()
	
	$CanvasLayer.visible = true
	showDialog("It seems like Evil hides in this ruin.", "Vedal:")
	await pressedEnter
	showDialog("I still don't understand, why she would do something like this.", "Anny:")
	await pressedEnter
	showDialog("Wait, whats over there?", "Neuro:")
	await pressedEnter
	$CanvasLayer.visible = false
	
	var tween1 = create_tween()
	tween1.tween_property($Camera2D, "position", Vector2($Camera2D.position.x, $Camera2D.position.y - (64*5)), 1).set_trans(Tween.TRANS_LINEAR)
	await tween1.finished
	await get_tree().create_timer(1).timeout
	
	$CanvasLayer.visible = true
	showDialog("There she is!", "Vedal:")
	await pressedEnter
	showDialog("But who is that next to her?", "Neuro:")
	await pressedEnter
	showDialog("That kinda looks like our friend Mini.", "Anny:")
	await pressedEnter
	showDialog("It seems to be a fragment of Neuros memories. Evil probably summoned her to hold us of.", "Vedal:")
	await pressedEnter
	
	$CanvasLayer/MarginContainer/ColorRect.color = red
	
	showDialog("Thats right, if you want to get to me, you must defeat the memories of your Past.", "Evil:")
	await pressedEnter
	showDialog("Are you ready or are you too much of a chicken?", "Evil:")
	await pressedEnter
	$CanvasLayer.visible = false
	
	var tween2 = create_tween()
	tween2.tween_property($Camera2D, "position", Vector2($Camera2D.position.x, $Camera2D.position.y + (64*5)), 1).set_trans(Tween.TRANS_LINEAR)
	await tween2.finished
	await get_tree().create_timer(0.3).timeout
	
	$CanvasLayer/MarginContainer/ColorRect.color = blue
	$CanvasLayer.visible = true
	showDialog("That's just cruel.", "Anny:")
	await pressedEnter
	showDialog("How do I always get into these scenarios.", "Vedal:")
	await pressedEnter
	showDialog("If thats what I have to do, then I will do it.", "Neuro:")
	await pressedEnter
	showDialog("I'm ready.", "Neuro:")
	await pressedEnter

	var tween3 = create_tween()
	tween3.tween_property($Camera2D, "zoom", Vector2(1, 1), 1).set_trans(Tween.TRANS_SINE)
	await $FadeContainer.fade_in()
	get_tree().change_scene_to_file("res://src/Map1/Map1.tscn")

func _input(event):
	if event.is_action_pressed("enter"):
		pressedEnter.emit()

func showDialog(text, name = ''):
	$CanvasLayer/MarginContainer/VBoxContainer/Label.text = name
	$CanvasLayer/MarginContainer/VBoxContainer/Label2.visible_characters = 0
	$CanvasLayer/MarginContainer/VBoxContainer/Label2.text = text
	
