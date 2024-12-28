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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit_health = unit_maxhealth
	current_position = [floor(position.x / Globals.tile_size), floor(position.y / Globals.tile_size)]
	set_pos()
	get_parent().add_unit(self, current_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_pos(time:float = 0.2):
	var new_pos = Vector2(current_position[0] * Globals.tile_size + (Globals.tile_size/2), current_position[1] * Globals.tile_size + (Globals.tile_size/2))
	var tween = create_tween()
	tween.tween_property(self, "position", new_pos, time).set_trans(Tween.TRANS_SINE)

func take_damage(value):
	unit_health -= value
	get_parent().new_cursor_position()
	var old_modulate = modulate
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,0,0,1), 0.1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate", old_modulate, 0.1)
	await tween.finished
	
	if(unit_health <= 0):
		var deathtween = create_tween()
		deathtween.tween_property(self, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_SINE)
		await deathtween.finished
		get_parent().units.erase(str(current_position[0], '_', current_position[1]))
		get_parent().new_cursor_position()

func set_used():
	used = true;
	self.modulate = Color(0.5, 0.5, 0.5, 1)
	get_parent().check_end_turn()

func set_free():
	used = false;
	self.modulate = Color(1, 1, 1, 1)

func do_turn():
	await get_tree().create_timer(1).timeout
