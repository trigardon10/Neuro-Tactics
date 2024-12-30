extends "res://src/unit.gd"

var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit_name = 'Lost Memory'
	unit_power = 3
	unit_maxhealth = 8
	unit_range = 4
	unit_attack_range = 1
	friendly = false
	super._ready()

func do_turn():
	await get_tree().create_timer(0.5).timeout
	
	if(!active):
		await get_tree().create_timer(0.5).timeout
		return
	
	$"../Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
	$"../Sounds".play()
	
	var friendly_units = []
	for unit in get_parent().units.values():
		if(unit.friendly):
			friendly_units.append(unit)
	
	var closest_distance = 0
	var closest_tile = null
	
	var tiles = get_parent().get_movable_tiles(current_position, unit_range, false)
	for tile in tiles.values():
		get_parent().tilemap_highlight.set_cell(Vector2i(tile['pos'][0], tile['pos'][1]), 2, Vector2i.ZERO)
		var tile_unit = get_parent().get_unit(tile.pos)
		if(tile_unit == null || tile_unit == self):
			var distance = get_smallest_distance(tile.pos, friendly_units)
			if(closest_tile == null || distance < closest_distance):
				closest_distance = distance
				closest_tile = tile
	
	get_parent().play_animation(self, "walk")
	await get_tree().create_timer(0.5).timeout
	
	$"../Cursor".current_position = closest_tile.pos.duplicate()
	$"../Cursor".set_pos(0.2)
	
	await get_tree().create_timer(0.5).timeout
	
	$"../Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
	$"../Sounds".play()
	
	get_parent().units.erase(str(current_position[0], '_', current_position[1]))
	self.current_position = closest_tile.pos.duplicate()
	
	self.set_pos(0.2)
	get_parent().play_animation(self, "idle")
	get_parent().add_unit(self, current_position)
	
	await get_tree().create_timer(0.2).timeout
	
	get_parent().tilemap_highlight.clear()
	
	await get_tree().create_timer(0.5).timeout
	
	
	if(closest_distance == 1):
		var unit_to_attack = null
		tiles = get_parent().get_in_range_tiles(current_position, 1)
		for tile in tiles.values():
			get_parent().tilemap_highlight.set_cell(Vector2i(tile['pos'][0], tile['pos'][1]), 2, Vector2i.DOWN)
			var tile_unit = get_parent().get_unit(tile.pos)
			if(tile_unit != null && tile_unit.friendly):
				unit_to_attack = tile_unit
		
		if(unit_to_attack == null):
			get_parent().tilemap_highlight.clear()
			return
		
		get_parent().play_animation(self, "atk")
		await get_tree().create_timer(0.5).timeout
		
		$"../Cursor".current_position = unit_to_attack.current_position.duplicate()
		$"../Cursor".set_pos()
		
		await get_tree().create_timer(0.5).timeout
		
		$"../Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
		$"../Sounds".play()
		
		get_parent().tilemap_highlight.clear()
		await get_parent().animate_attack(self, unit_to_attack)
		await unit_to_attack.take_damage(unit_power)
		get_parent().play_animation(self, "idle")
		
		if(!is_inside_tree()):
			return
		
		await get_tree().create_timer(0.5).timeout
