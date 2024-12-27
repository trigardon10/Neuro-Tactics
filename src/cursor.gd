extends Area2D

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x -= fmod(position.x, Globals.tile_size)
	position.y -= fmod(position.y, Globals.tile_size)
	position += Vector2.ONE * Globals.tile_size/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	position += inputs[dir] * Globals.tile_size
