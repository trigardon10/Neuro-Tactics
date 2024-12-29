extends "res://src/unit.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit_name = 'Anny'
	unit_power = 2
	unit_maxhealth = 8
	unit_range = 5
	unit_attack_range = 5
	special_name = "Healing Star"
	special_tooltip = "Restores health to an ally within range."
	super._ready()

func use_special():
	get_parent().special_tiles = get_parent().get_in_range_tiles(current_position, unit_attack_range)
	for tile in get_parent().special_tiles.values():
		get_parent().tilemap_highlight.set_cell(Vector2i(tile['pos'][0], tile['pos'][1]), 2, Vector2i.RIGHT)
	get_parent().special_mode = true

func viable_special_unit(unit):
	return unit.friendly

func finish_special(unit):
	get_parent().in_combat = true
	await get_parent().animate_attack(self, unit)
	await unit.take_damage(-20)
	set_used()
	get_parent().in_combat = false
	set_used()
