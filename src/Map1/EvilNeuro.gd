extends "res://src/unit.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit_name = 'Evil Neuro'
	unit_power = 4
	unit_maxhealth = 20
	unit_range = 0
	unit_attack_range = 5
	friendly = false
	sprite = preload("res://assets/sprites/harpoon.png")
	force_sprite = true
	super._ready()

func take_damage(value):
	await super.take_damage(value)
	if(unit_health <= 0):
		await $"../FadeContainer".fade_in()
		get_tree().change_scene_to_file("res://src/Outro/outro.tscn")

func do_turn():
	await get_tree().create_timer(0.5).timeout
	
	var friendly_units = []
	for unit in get_parent().units.values():
		if(unit.friendly && get_distance(current_position, unit.current_position) <= unit_attack_range):
			friendly_units.append(unit)
	
	if(friendly_units.size() > 0):
		var tiles = get_parent().get_in_range_tiles(current_position, unit_attack_range)
		for tile in tiles.values():
			get_parent().tilemap_highlight.set_cell(Vector2i(tile['pos'][0], tile['pos'][1]), 2, Vector2i.DOWN)
		
		$"../Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
		$"../Sounds".play()
		
		await get_tree().create_timer(0.5).timeout
		
		for unit_to_attack in friendly_units:
			
			$"../Cursor".current_position = unit_to_attack.current_position.duplicate()
			$"../Cursor".set_pos(0.2)
			
			await get_tree().create_timer(0.5).timeout
			
			$"../Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
			$"../Sounds".play()
			
			await get_parent().animate_attack(self, unit_to_attack)
			await unit_to_attack.take_damage(unit_power)
			
			if(!is_inside_tree()):
				return
			
			await get_tree().create_timer(0.3).timeout
		
		get_parent().tilemap_highlight.clear()
		
		$"../Cursor".current_position = current_position.duplicate()
		$"../Cursor".set_pos(0.2)
		
	await get_tree().create_timer(0.5).timeout
