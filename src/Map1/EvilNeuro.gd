extends "res://src/unit.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit_name = 'Evil Neuro'
	unit_power = 4
	unit_maxhealth = 20
	unit_range = 0
	unit_attack_range = 5
	friendly = false
	super._ready()
