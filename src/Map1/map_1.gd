extends Node2D

var mapsize: Vector2i
var units: Dictionary = {}
var movement_mode = false
var attack_mode = false
var special_mode = false
var movable_tiles: Dictionary = {}
var attackable_tiles: Dictionary = {}
var special_tiles: Dictionary = {}
var movement_unit: Node2D
var tilemap: TileMapLayer
var tilemap_highlight: TileMapLayer
var in_combat = false
var enemy_turn = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap = find_child("TileMapLayer")
	tilemap_highlight = find_child("HighlightedTiles")
	mapsize = tilemap.get_used_rect().size

func add_unit(unit: Node2D, unit_position: Array):
	units[str(unit_position[0], '_', unit_position[1])] = unit;
	new_cursor_position()

func get_unit(unit_position: Array) -> Node2D:
	if(units.has(str(unit_position[0], '_', unit_position[1]))):
		return units[str(unit_position[0], '_', unit_position[1])];
	return null

func new_cursor_position():
	var unit = get_unit($Cursor.current_position)
	var unit_overlay: CanvasLayer = $"Unit Overlay"
	if(unit):
		unit_overlay.new_unit(unit)
		unit_overlay.visible = true
	else:
		unit_overlay.visible = false

func enter(unit_position: Array):
	var unit_pos_str = str(unit_position[0], '_', unit_position[1])
	if(movement_mode):
		if(get_unit(unit_position) != null && get_unit(unit_position).friendly && get_unit(unit_position) != movement_unit):
			end_movement()
			return enter(unit_position)
		elif(movable_tiles.has(unit_pos_str)):
			$"Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
			$"Sounds".play()
			var oldPos = movement_unit.current_position.duplicate()
			movement_unit.current_position = movable_tiles.get(unit_pos_str).pos
			movement_unit.set_pos()
			units.erase(str(oldPos[0], '_', oldPos[1]))
			add_unit(movement_unit, movement_unit.current_position)
			end_movement()
			open_action_menu()
	elif(attack_mode):
		if(attackable_tiles.has(unit_pos_str) && get_unit(unit_position) != null && !get_unit(unit_position).friendly):
			$"Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
			$"Sounds".play()
			combat(movement_unit, get_unit(unit_position))
			end_attack()
	elif(special_mode):
		if(special_tiles.has(unit_pos_str) && get_unit(unit_position) != null && movement_unit.viable_special_unit(get_unit(unit_position))):
			$"Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
			$"Sounds".play()
			movement_unit.finish_special(get_unit(unit_position))
			end_special()
	else:
		var unit = get_unit(unit_position)
		if(unit && unit.friendly && !unit.used):
			$"Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
			$"Sounds".play()
			print(unit.unit_name)
			start_movement(unit, unit_position)

func start_movement(unit: Node2D, unit_position: Array):
	play_animation(unit, "walk")
	var unit_range = unit.unit_range
	movable_tiles = get_movable_tiles(unit_position, unit_range)
	for tile in movable_tiles.values():
		tilemap_highlight.set_cell(Vector2i(tile['pos'][0], tile['pos'][1]), 2, Vector2i.ZERO)
	movement_mode = true
	movement_unit = unit

func get_movable_tiles(unit_position, unit_range, friendly = true) -> Dictionary:
	var found_tiles: Dictionary = {}
	found_tiles[str(unit_position[0], '_', unit_position[1])] = {"pos" = unit_position.duplicate(), "distance" = 0}
	var current_findings = found_tiles.values()
	var new_findings = []
	for i in range(0, unit_range):
		for found_tile in current_findings:
			#left
			var newpos = [found_tile.pos[0]+1, found_tile.pos[1]]
			var newposstr = str(newpos[0], '_', newpos[1])
			if(!found_tiles.has(newposstr) && is_movable(newpos, friendly)):
				found_tiles[newposstr] = {"pos" = newpos, "distance" = i + 1}
				new_findings.append(found_tiles[newposstr])
			#right
			newpos = [found_tile.pos[0]-1, found_tile.pos[1]]
			newposstr = str(newpos[0], '_', newpos[1])
			if(!found_tiles.has(newposstr) && is_movable(newpos, friendly)):
				found_tiles[newposstr] = {"pos" = newpos, "distance" = i + 1}
				new_findings.append(found_tiles[newposstr])
			#up
			newpos = [found_tile.pos[0], found_tile.pos[1]-1]
			newposstr = str(newpos[0], '_', newpos[1])
			if(!found_tiles.has(newposstr) && is_movable(newpos, friendly)):
				found_tiles[newposstr] = {"pos" = newpos, "distance" = i + 1}
				new_findings.append(found_tiles[newposstr])
			#down
			newpos = [found_tile.pos[0], found_tile.pos[1]+1]
			newposstr = str(newpos[0], '_', newpos[1])
			if(!found_tiles.has(newposstr) && is_movable(newpos, friendly)):
				found_tiles[newposstr] = {"pos" = newpos, "distance" = i + 1}
				new_findings.append(found_tiles[newposstr])
		current_findings = new_findings
		new_findings = []
	return found_tiles

func is_in_bounds(unit_position: Array) -> bool:
	return unit_position[0] >= 0 && unit_position[0] < mapsize.x && unit_position[1] >= 0 && unit_position[1] < mapsize.y

func is_movable(unit_position: Array, friendly = true) -> bool:
	# oob checks
	var is_in_bounds = is_in_bounds(unit_position)

	var tile_atlas_coords = tilemap.get_cell_atlas_coords(Vector2i(unit_position[0], unit_position[1]))
	var no_wall = tile_atlas_coords.y > 3
	
	var is_free = get_unit(unit_position) == null || get_unit(unit_position).friendly == friendly
	
	return is_in_bounds && no_wall && is_free

func end_movement():
	movable_tiles = {}
	tilemap_highlight.clear()
	play_animation(movement_unit, "idle")
	movement_mode = false

func start_attack():
	var unit_attack_range = movement_unit.unit_attack_range
	attackable_tiles = get_in_range_tiles(movement_unit.current_position, unit_attack_range)
	play_animation(movement_unit, "atk")

	for tile in attackable_tiles.values():
		tilemap_highlight.set_cell(Vector2i(tile['pos'][0], tile['pos'][1]), 2, Vector2i.DOWN)
	attack_mode = true

func get_in_range_tiles(unit_position, unit_range) -> Dictionary:
	var found_tiles: Dictionary = {}
	for x in range(-unit_range, unit_range + 1):
		var distance_x = abs(x)
		var distance_y = unit_range - distance_x
		for y in range(-distance_y, distance_y + 1):
			var newpos = [unit_position[0]+x, unit_position[1]+y]
			var newposstr = str(newpos[0], '_', newpos[1])
			if(is_in_bounds(newpos) && !(x == 0 && y == 0)):
				found_tiles[newposstr] = {"pos" = newpos, "distance" = unit_range - (distance_x + distance_y)}
	return found_tiles

func combat(attacking, target):
	in_combat = true
	await animate_attack(attacking, target)
	await target.take_damage(attacking.unit_power)
	await movement_unit.set_used()
	play_animation(movement_unit, "idle")
	in_combat = false

func animate_attack(attacking: Node2D, target: Node2D):
	var distance = attacking.get_distance_to(target)
	var vector_attacking = Vector2i(attacking.current_position[0], attacking.current_position[1])
	var vector_target = Vector2i(target.current_position[0], target.current_position[1])
	var vector_diff = Vector2(vector_target - vector_attacking)
	if(attacking.sprite != null && (distance > 1 || attacking.force_sprite)):
		var distance_direct = vector_attacking.distance_to(vector_target)
		var scale_x = 1
		if(vector_diff.x <= 0):
			vector_diff.x = abs(vector_diff.x)
			vector_diff.y = -vector_diff.y
			scale_x = -1
		$Projectile.position = Vector2(attacking.position)
		$Projectile/Sprite2D.texture = attacking.sprite
		$Projectile.rotation = vector_diff.angle() if !attacking.dont_rotate else 0
		$Projectile.scale.x = scale_x
		$Projectile.visible = true
		var tween = create_tween()
		tween.tween_property($Projectile, "position", Vector2(target.position), distance_direct * 0.05 + 0.2).set_trans(Tween.TRANS_SINE)
		await tween.finished
		$Projectile.visible = false
	elif (distance == 1):
		var tween = create_tween()
		tween.tween_property(attacking, "position", attacking.position + (vector_diff * 32), 0.05).set_trans(Tween.TRANS_SINE)
		await tween.finished
		attacking.set_pos(0.05)
		# TODO melee

func end_attack():
	attackable_tiles = {}
	tilemap_highlight.clear()
	attack_mode = false

func end_special():
	special_tiles = {}
	tilemap_highlight.clear()
	play_animation(movement_unit, "idle")
	special_mode = false

func cancel(_unit_position: Array):
	if(movement_mode):
		$"Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
		$"Sounds".play()
		end_movement()
		$Cursor.current_position = movement_unit.current_position.duplicate()
		$Cursor.set_pos()
		play_animation(movement_unit, "idle")
	if(attack_mode):
		$"Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
		$"Sounds".play()
		end_attack()
		$Cursor.current_position = movement_unit.current_position.duplicate()
		$Cursor.set_pos()
		open_action_menu()
		play_animation(movement_unit, "walk")
	if(special_mode):
		$"Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
		$"Sounds".play()
		end_special()
		$Cursor.current_position = movement_unit.current_position.duplicate()
		$Cursor.set_pos()
		open_action_menu()
		play_animation(movement_unit, "walk")

func open_action_menu():
	$Popup/PopupMenu/VBoxContainer/Attack.grab_focus()
	$Popup/PopupMenu/VBoxContainer/Special/VBoxContainer/Label.text = movement_unit.special_name
	$Popup/PopupMenu/VBoxContainer/Special/VBoxContainer/Tooltip.text = movement_unit.special_tooltip
	$Popup/PopupMenu.position.x = (get_viewport_rect().size.x/2) - ($Popup/PopupMenu.get_rect().size.x/2)
	$Popup/PopupMenu.position.y = (get_viewport_rect().size.y/2) + 34
	$Popup.show()

func check_end_turn(ended_unit):
	if(ended_unit.current_position[0] != $Cursor.current_position[0] || ended_unit.current_position[1] != $Cursor.current_position[1]):
		$Cursor.current_position = ended_unit.current_position.duplicate()
		await $Cursor.set_pos(0.2)
	
	if(ended_unit.current_position[1] <= 18):
		$Memory2.active = true
		$Memory3.active = true
		$Memory4.active = true
	
	for unit in units.values():
		if(unit.friendly && !unit.used):
			return
	
	enemy_turn = true
	$"Turn overlay/Container/Label".text = "Enemy Turn"
	
	await get_tree().create_timer(0.3).timeout
	
	# All Units used
	for unit in units.values():
		if(unit.friendly):
			unit.set_free()
	
	do_enemy_turn()

func do_enemy_turn():
	var sortet_units = units.values()
	sortet_units.sort_custom(custom_index_sort)
	for unit in sortet_units:
		if(!unit.friendly):
			if(!is_inside_tree()):
				return
			$Cursor.current_position = unit.current_position.duplicate()
			$Cursor.set_pos(0.2)
			await unit.do_turn()
			if(!is_inside_tree()):
				return
	$Cursor.current_position = $"Neuro-sama".current_position.duplicate()
	await $Cursor.set_pos(0.2)
	enemy_turn = false
	$"Turn overlay/Container/Label".text = "Your Turn"

func custom_index_sort(a: Node, b: Node) -> bool:
	return a.get_index() < b.get_index()

func _on_attack_pressed() -> void:
	$Popup.hide()
	$"Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
	$"Sounds".play()
	start_attack()

func _on_special_pressed() -> void:
	$Popup.hide()
	$"Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
	$"Sounds".play()
	await movement_unit.use_special()

func _on_wait_pressed() -> void:
	$Popup.hide()
	$"Sounds".stream = preload("res://assets/sounds/coin-collect-retro-8-bit-sound-effect-145251.mp3")
	$"Sounds".play()
	movement_unit.set_used()


func _on_color_rect_ready() -> void:
	await $FadeContainer.fade_out()
	enemy_turn = false


func _on_memory_1_ready() -> void:
	$Memory1.active = true
	
func play_animation(unit, anim_name):
	if unit.animated_sprite_2d != null:
		unit.animated_sprite_2d.play(anim_name)
