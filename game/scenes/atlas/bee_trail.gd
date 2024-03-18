extends Node2D

@export var line_width = 10:
	set(value):
		line_width = value
		update()

@export var line_dash = 5:
	set(value):
		line_dash = value
		update()

@export var line_repeat = true:
	set(value):
		line_repeat = value
		update()

@export var color = Color.BLACK:
	set(value):
		color = value
		update()

var points = []:
	set(value):
		points = value
		update()

func update():
	if not is_node_ready():
		await ready
	print_debug("queue redraw")
	queue_redraw()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _draw() -> void:
	var curve = Curve2D.new()

	for i in points.size():
		var pos = points[i]
		var control_in = Vector2.ZERO
		var control_out = Vector2.ZERO

		curve.add_point(pos, control_in, control_out)

	draw_dotted_line(curve, 20)

	#draw_circle(Vector2(100, 100), 50, Color.RED)
	#draw_polyline(curve.get_baked_points(), color, 2.0)

func draw_dotted_line(curve: Curve2D, point_dist: float):
	var baked_points = curve.get_baked_points()
	var point_count = baked_points.size()
	var last_point = Vector2(0,0)
	var current_point = Vector2(0,0)
	var distance = 0.0
	var _point_index = 0

	for i in range(point_count):
		current_point = baked_points[i]
		if i > 0:
			distance += last_point.distance_to(current_point)
			while distance > point_dist:
				_point_index = i - 1
				var t = 0.50
				var circle_point = last_point.lerp(current_point,t)
				draw_circle(round(circle_point),4,Color.YELLOW)
				distance -= point_dist
		last_point = current_point
