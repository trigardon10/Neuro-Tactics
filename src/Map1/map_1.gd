extends Node2D

var mapsize: Vector2i
var units: Dictionary = {}
var movement_mode = false
var movable_tiles: Dictionary = {}
var movement_unit: Node2D
var tilemap: TileMapLayer
var tilemap_highlight: TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap = find_child("TileMapLayer")
	tilemap_highlight = find_child("HighlightedTiles")
	mapsize = tilemap.get_used_rect().size

func add_unit(unit: Node2D, unit_position: Array):
	units[str(unit_position[0], '_', unit_position[1])] = unit;

func get_unit(unit_position: Array) -> Node2D:
	if(units.has(str(unit_position[0], '_', unit_position[1]))):
		return units[str(unit_position[0], '_', unit_position[1])];
	return null

func enter(unit_position: Array):
	if(movement_mode):
		var unit_pos_str = str(unit_position[0], '_', unit_position[1])
		if(movable_tiles.has(unit_pos_str)):
			movement_unit.current_position = movable_tiles.get(unit_pos_str).pos
			movement_unit.set_pos()
			units.erase(unit_pos_str)
			add_unit(movement_unit, movement_unit.current_position)
			end_movement()
	else:
		var unit = get_unit(unit_position)
		if(unit && unit.friendly):
			print(unit.unit_name)
			start_movement(unit, unit_position)

func start_movement(unit: Node2D, unit_position: Array):
	var unit_range = unit.unit_range
	movable_tiles = get_movable_tiles(unit_position, unit_range)
	for tile in movable_tiles.values():
		tilemap_highlight.set_cell(Vector2i(tile['pos'][0], tile['pos'][1]), 2, Vector2i.ZERO)
	movement_mode = true
	movement_unit = unit

func get_movable_tiles(unit_position, unit_range) -> Dictionary:
	var found_tiles: Dictionary = {}
	found_tiles[str(unit_position[0], '_', unit_position[1])] = {"pos" = unit_position, "distance" = 0}
	var current_findings = found_tiles.values()
	var new_findings = []
	for i in range(0, unit_range):
		for found_tile in current_findings:
			#left
			var newpos = [found_tile.pos[0]+1, found_tile.pos[1]]
			var newposstr = str(newpos[0], '_', newpos[1])
			if(!found_tiles.has(newposstr) && is_movable(newpos)):
				found_tiles[newposstr] = {"pos" = newpos, "distance" = i + 1}
				new_findings.append(found_tiles[newposstr])
			#right
			newpos = [found_tile.pos[0]-1, found_tile.pos[1]]
			newposstr = str(newpos[0], '_', newpos[1])
			if(!found_tiles.has(newposstr) && is_movable(newpos)):
				found_tiles[newposstr] = {"pos" = newpos, "distance" = i + 1}
				new_findings.append(found_tiles[newposstr])
			#up
			newpos = [found_tile.pos[0], found_tile.pos[1]-1]
			newposstr = str(newpos[0], '_', newpos[1])
			if(!found_tiles.has(newposstr) && is_movable(newpos)):
				found_tiles[newposstr] = {"pos" = newpos, "distance" = i + 1}
				new_findings.append(found_tiles[newposstr])
			#down
			newpos = [found_tile.pos[0], found_tile.pos[1]+1]
			newposstr = str(newpos[0], '_', newpos[1])
			if(!found_tiles.has(newposstr) && is_movable(newpos)):
				found_tiles[newposstr] = {"pos" = newpos, "distance" = i + 1}
				new_findings.append(found_tiles[newposstr])
		current_findings = new_findings
		new_findings = []
	return found_tiles

func is_movable(unit_position: Array) -> bool:
	# oob checks
	var is_in_bounds = unit_position[0] >= 0 && unit_position[0] < mapsize.x && unit_position[1] >= 0 && unit_position[1] < mapsize.y

	var tile_atlas_coords = tilemap.get_cell_atlas_coords(Vector2i(unit_position[0], unit_position[1]))
	var no_wall = tile_atlas_coords.y > 0
	#todo Other Unit checks
	
	return is_in_bounds && no_wall

func end_movement():
	movable_tiles = {}
	tilemap_highlight.clear()
	movement_mode = false
	movement_unit = null

func cancel(_unit_position: Array):
	if(movement_mode):
		end_movement()
