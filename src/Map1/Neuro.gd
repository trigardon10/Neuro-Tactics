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
	sprite = preload("res://assets/sprites/drone.png")
	super._ready()

func take_damage(value):
	await super.take_damage(value)
	if(unit_health <= 0):
		$"../Defeat  Overlay/Container".modulate = Color(1,1,1,0)
		$"../Defeat  Overlay".visible = 1
		var tween = create_tween()
		tween.tween_property($"../Defeat  Overlay/Container", "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_SINE)
		var sound_tween = create_tween()
		sound_tween.tween_property($"../Music", "volume_db", -80, 1).set_trans(Tween.TRANS_SINE)
		await tween.finished
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://src/Title/title.tscn")

func use_special():
	get_parent().special_tiles = get_parent().get_in_range_tiles(current_position, 1)
	for tile in get_parent().special_tiles.values():
		get_parent().tilemap_highlight.set_cell(Vector2i(tile['pos'][0], tile['pos'][1]), 2, Vector2i.DOWN)
	get_parent().special_mode = true

func viable_special_unit(unit):
	return !unit.friendly

func finish_special(unit):
	unit_power = 6
	await get_parent().combat(self, unit)
	unit_power = 3
