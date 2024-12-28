extends CanvasLayer

var blue = Color(0.2, 0.4, 1, 1)
var red = Color(0.8, 0.2, 0.2, 1)

func new_unit(unit: Node2D):
	var name_lbl = $"Container/Unit Stats/MarginContainer/HBoxContainer/VBoxContainer/Name"
	var alignment_lbl = $"Container/Unit Stats/MarginContainer/HBoxContainer/VBoxContainer/Alignment"
	var health_lbl = $"Container/Unit Stats/MarginContainer/HBoxContainer/VBoxContainer2/Health"
	var attack_lbl = $"Container/Unit Stats/MarginContainer/HBoxContainer/VBoxContainer2/Attack"
	var movement_lbl = $"Container/Unit Stats/MarginContainer/HBoxContainer/VBoxContainer3/Movement"
	var range_lbl = $"Container/Unit Stats/MarginContainer/HBoxContainer/VBoxContainer3/Range"
	
	name_lbl.text = unit.unit_name
	alignment_lbl.text = "friendly" if unit.friendly else "hostile"
	health_lbl.text = str('Health: ', unit.unit_health, '/', unit.unit_maxhealth)
	attack_lbl.text = str('Attack: ', unit.unit_power)
	movement_lbl.text = str('Movement: ', unit.unit_range)
	range_lbl.text = str('Range:    ', unit.unit_attack_range)
	
	$"Container/Unit Stats".color = blue if unit.friendly else red
