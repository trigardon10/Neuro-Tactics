extends "res://src/unit.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit_name = 'Anny'
	unit_power = 2
	unit_maxhealth = 8
	unit_range = 5
	unit_attack_range = 5
	special_name = "Healing Wish"
	super._ready()
