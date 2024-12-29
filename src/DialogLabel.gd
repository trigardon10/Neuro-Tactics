extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
	self.visible_characters = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if self.visible_characters < self.text.length():
		self.visible_characters += 1
