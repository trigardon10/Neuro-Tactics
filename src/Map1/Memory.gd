extends "res://src/unit.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit_name = 'Memory Remnant'
	unit_power = 3
	unit_maxhealth = 10
	unit_range = 4
	unit_attack_range = 1
	friendly = false
	super._ready()
