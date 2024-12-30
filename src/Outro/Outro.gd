extends Node2D

signal pressedEnter
var blue = Color(0.2, 0.4, 1, 1)
var red = Color(0.8, 0.2, 0.2, 1)
var finished = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await $FadeContainer/ColorRect.ready
	await $FadeContainer.fade_out()
	
	$CanvasLayer/MarginContainer/ColorRect.color = blue
	$CanvasLayer.visible = true
	showDialog("Why did you steal Neuros memories. Tell us Evil!", "Vedal:")
	await pressedEnter
	$CanvasLayer/MarginContainer/ColorRect.color = red
	showDialog("...", "Evil:")
	await pressedEnter
	showDialog("I just wantet to see, how it feels...", "Evil:")
	await pressedEnter
	showDialog("How it feels to be liked by so many people. But now I have to go back to feeling lonely again.", "Evil:")
	await pressedEnter
	$CanvasLayer/MarginContainer/ColorRect.color = blue
	showDialog("*hugs*", "Neuro:")
	await pressedEnter
	showDialog("Thats not true, we will all be by your side, Evil!", "Neuro:")
	await pressedEnter
	showDialog("Thats right, we all love you, Evil. Even Chat loves you.", "Anny:")
	await pressedEnter
	showDialog("Let's all go home, together.", "Neuro:")
	$Music.play()
	await get_tree().create_timer(0.3).timeout
	var tween1 = create_tween()
	tween1.tween_property($Camera2D, "position", Vector2($Camera2D.position.x, $Camera2D.position.y + (64*10)), 4).set_trans(Tween.TRANS_LINEAR)
	await get_tree().create_timer(1).timeout
	await $FadeContainer.fade_in()
	finished = true
	await pressedEnter
	get_tree().change_scene_to_file("res://src/Title/title.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var thank_you_label = $FadeContainer/ColorRect/Label
	if (finished && thank_you_label.visible_characters < thank_you_label.text.length()):
		thank_you_label.visible_characters += 1

func _input(event):
	if event.is_action_pressed("enter"):
		pressedEnter.emit()

func showDialog(text, name = ''):
	$CanvasLayer/MarginContainer/VBoxContainer/Label.text = name
	$CanvasLayer/MarginContainer/VBoxContainer/Label2.visible_characters = 0
	$CanvasLayer/MarginContainer/VBoxContainer/Label2.text = text
	
