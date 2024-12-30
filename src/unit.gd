extends Area2D

var unit_name = "x"
var unit_power = 1
var unit_maxhealth = 1
var unit_range = 1
var unit_attack_range = 1
var unit_health
var friendly = true
var current_position = [0, 0]
var special_name = "null"
var special_tooltip = "null"
var used = false
var force_sprite = false

var animated_sprite_2d: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit_health = unit_maxhealth
	current_position = [floor(position.x / Globals.tile_size), floor(position.y / Globals.tile_size)]
	set_pos()
	get_parent().add_unit(self, current_position)
	animated_sprite_2d = get_node("AnimatedSprite2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_pos(time:float = 0.2):
	var new_pos = Vector2(current_position[0] * Globals.tile_size + (Globals.tile_size/2), current_position[1] * Globals.tile_size + (Globals.tile_size/2))
	
	if animated_sprite_2d != null:
		animated_sprite_2d.play("walk")
		
	var tween = create_tween()
	
	tween.tween_property(self, "position", new_pos, time).set_trans(Tween.TRANS_SINE)
	
	#if animated_sprite_2d != null:
		#print("ayy")


func take_damage(value):
	unit_health -= value
	if unit_health < 0:
		unit_health = 0
	if unit_health > unit_maxhealth:
		unit_health = unit_maxhealth
	get_parent().new_cursor_position()
	$"../Sounds".stream = preload("res://assets/sounds/retro-hurt-1-236672.mp3") if value >= 0 else preload("res://assets/sounds/experimental-8-bit-sound-270302.mp3")
	$"../Sounds".play()
	var old_modulate = modulate
	var tween = create_tween()
	var mod_color = Color(1,0,0,1) if value >= 0 else Color(0.5,1,0.5,1)
	var mod_time = 0.1 if value >= 0 else 0.3
	tween.tween_property(self, "modulate", mod_color, mod_time).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate", old_modulate, mod_time)
	await tween.finished
	
	if(unit_health <= 0):
		$"../Sounds".stream = preload("res://assets/sounds/retro-explode-1-236678.mp3")
		$"../Sounds".play()
		var deathtween = create_tween()
		deathtween.tween_property(self, "modulate", Color(1,1,1,0), 0.6).set_trans(Tween.TRANS_SINE)
		await deathtween.finished
		get_parent().units.erase(str(current_position[0], '_', current_position[1]))
		get_parent().new_cursor_position()

func set_used():
	used = true;
	self.modulate = Color(0.5, 0.5, 0.5, 1)
	await get_parent().check_end_turn(self)

func set_free():
	used = false;
	self.modulate = Color(1, 1, 1, 1)

func do_turn():
	await get_tree().create_timer(1).timeout

func use_special():
	await take_damage(20)
	set_used()

func viable_special_unit(_unit):
	return true

func finish_special(_unit):
	set_used()


func get_smallest_distance(pos, units):
	var smallest_distance = -1
	for unit in units:
		var distance = get_distance(pos, unit.current_position)
		if(smallest_distance == -1 || distance < smallest_distance):
			smallest_distance = distance
	return smallest_distance

func get_distance(pos1, pos2):
	var x = abs(pos1[0] - pos2[0])
	var y = abs(pos1[1] - pos2[1])
	return x+y
