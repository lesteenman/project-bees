extends Node2D

var offset = Vector2.ZERO
var highlighted_tiles = []:
	set(value):
		#position = value[0]

		#offset = position
		highlighted_tiles = value
		update()

@export var circle_radius = 50
@export var circle_color = Color.RED


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var pressing_at = Vector2.ZERO
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pressing_at = event.position

		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			var drag_distance = pressing_at.distance_to(event.position)
			if drag_distance >= 30:
				return

			#print_debug("clicked at ", event.position, " relative to ", $PanelContainer.position, " or ", $PanelContainer.global_position)
			print(event.global_position, event.position)
			print(get_local_mouse_position())

			highlighted_tiles = [get_local_mouse_position()]

func update():
	if not is_node_ready():
		await ready
	#print("set position, my relative position is ", get_viewport_rect())
	queue_redraw()


func _draw():
	for tile in highlighted_tiles:
		draw_circle(tile, circle_radius, circle_color)
