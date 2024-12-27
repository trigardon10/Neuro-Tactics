extends Area2D

var inputs = {
	"right": [1, 0],
	"left": [-1, 0],
	"up": [0, -1],
	"down": [0, 1]}

var hold={
	"right": false,
	"left": false,
	"up": false,
	"down": false}

var moving={
	"right": false,
	"left": false,
	"up": false,
	"down": false}

var current_position = [0, 0]

var move_delay = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	current_position = [floor(position.x / Globals.tile_size), floor(position.y / Globals.tile_size)]
	set_pos()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			hold[dir] = true;
			move(dir)
		if event.is_action_released(dir):
			hold[dir] = false
	if event.is_action_pressed("enter"):
		get_parent().enter(current_position)
	if event.is_action_pressed("cancel"):
		get_parent().cancel(current_position)

func move(dir):
	if(moving[dir]):
		return
	
	moving[dir] = true
	if(!hold[dir]):
		moving[dir] = false
		return
	
	current_position[0] += inputs[dir][0]
	current_position[1] += inputs[dir][1]

	# oob checks
	if(current_position[0] < 0):
		current_position[0] = 0;
	if(current_position[0] >= get_parent().mapsize.x):
		current_position[0] = get_parent().mapsize.x - 1;
	if(current_position[1] < 0):
		current_position[1] = 0;
	if(current_position[1] >= get_parent().mapsize.y):
		current_position[1] = get_parent().mapsize.y - 1;

	set_pos()
	
	await get_tree().create_timer(move_delay).timeout
	moving[dir] = false
	
	move(dir)

func set_pos():
	position.x = current_position[0] * Globals.tile_size + (Globals.tile_size/2)
	position.y = current_position[1] * Globals.tile_size + (Globals.tile_size/2)