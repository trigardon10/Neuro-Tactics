extends "res://src/unit.gd"

var turle_mode = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit_name = 'Vedal'
	unit_power = 2
	unit_maxhealth = 15
	unit_range = 4
	unit_attack_range = 1
	special_name = "Turtle Shell"
	special_tooltip = "The next attack against Vedal does no damage."
	super._ready()

func set_pos(time:float = 0.2):
	turle_mode = false;
	return super.set_pos(time)

func use_special():
	turle_mode = true
	set_used()


func take_damage(value):
	if turle_mode:
		turle_mode = false
		var tween = create_tween()
		var old_modulate = modulate
		tween.tween_property(self, "modulate", Color(1,1,1,1), 0.1).set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "modulate", old_modulate, 0.1)
		await tween.finished
	else:
		await super.take_damage(value)
