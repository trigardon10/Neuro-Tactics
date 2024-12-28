extends "res://src/unit.gd"


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
