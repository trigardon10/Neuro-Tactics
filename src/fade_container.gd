extends CanvasLayer


func fade_in():
	self.visible = 1
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate", Color(1,1,1,1), 0.7).set_trans(Tween.TRANS_SINE)
	await tween.finished

func fade_out():
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate", Color(1,1,1,0), 0.7).set_trans(Tween.TRANS_SINE)
	await tween.finished
	self.visible = 0
