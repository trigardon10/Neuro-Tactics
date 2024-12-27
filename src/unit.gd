extends Area2D

var unit_name = "x"
var unit_power = 1
var unit_maxhealth = 1
var unit_range = 1
var unit_attack_range = 1
var unit_health
var friendly = true
var current_position = [0, 0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit_health = unit_maxhealth
	current_position = [floor(position.x / Globals.tile_size), floor(position.y / Globals.tile_size)]
	set_pos()
	get_parent().add_unit(self, current_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_pos():
	position.x = current_position[0] * Globals.tile_size + (Globals.tile_size/2)
	position.y = current_position[1] * Globals.tile_size + (Globals.tile_size/2)
