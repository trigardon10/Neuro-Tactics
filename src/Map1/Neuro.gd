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
