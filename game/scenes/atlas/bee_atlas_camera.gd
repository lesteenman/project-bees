extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#print_debug(event)
		if event.button_mask == MOUSE_BUTTON_LEFT:
			print_debug("move by", event.relative)
			position -= event.relative
