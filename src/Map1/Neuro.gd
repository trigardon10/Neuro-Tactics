extends "res://src/unit.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit_name = 'Neuro-sama'
	unit_power = 3
	unit_maxhealth = 10
	unit_range = 5
	unit_attack_range = 3
	special_name = "Swarm Strike"
	special_tooltip = "Powerful Attack. Can only target enemies next to Neuro."
	super._ready()

func take_damage(value):
	await super.take_damage(value)
	if(unit_health <= 0):
		$"../Defeat  Overlay/Container".modulate = Color(1,1,1,0)
		$"../Defeat  Overlay".visible = 1
		var tween = create_tween()
		tween.tween_property($"../Defeat  Overlay/Container", "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_SINE)
		await tween.finished
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://src/Title/title.tscn")
