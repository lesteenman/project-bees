@tool
extends TileMap

class_name BeeAtlasMap

@onready var tile_map: TileMap = %BeeAtlasMap
@onready var astar = AStar2D.new()
@onready var camera: Camera2D = %BeeAtlasCamera

@export var map_radius = 1:
	set(value):
		map_radius = value
		load_tiles()

const COORDS_EMPTY_CELL = Vector2i(1, 0)
const COORDS_LARVA_CELL = Vector2i(0, 0)
const LAYER_CELLS = 0
const SOURCE_ID = 1

var path_start: Vector2i
var path_end: Vector2i
var update_next = 'start'
var real_used_rect = Rect2(Vector2.ZERO, Vector2.ZERO)

signal map_size_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_tiles()

	#load_bees()
	#regenerate_nav()

func load_tiles() -> void:
	# TODO: Take the tile offset into account as well
	# TODO: Also populate a list of viable tiles to spawn the drones in,
	# and sort it by distance from the center.
	var screen_size = get_viewport_rect().size
	var tile_size = tile_map.tile_set.tile_size
	var min_rows = screen_size.y / tile_size.y
	var min_cols = screen_size.x / tile_size.x
	var min_radius = max(min_rows, min_cols)
	#var min_radius = max(get_viewport_rect().size.x, get_viewport_rect().size.y) / tile_map.tile_set.tile_size.x
	print("min radius ", min_radius, ", rows=", min_rows, " colrs=", min_cols)

	tile_map.clear()
	for y in range(-map_radius, map_radius + 1):
		var columns = range(-map_radius, map_radius + (1 if (abs(y) % 2) == 0 else 0))
		print("row ", y, " gets ", columns, " since abs(y) % 2 = ", abs(y) % 2)
		for x in columns:
			var map_coord = Vector2i(x, y)
			var larva = is_potential_larva(map_coord)
			tile_map.set_cell(LAYER_CELLS, map_coord, SOURCE_ID, COORDS_LARVA_CELL if larva else COORDS_EMPTY_CELL)

	update_real_used_size()
	update_camera()


func update_real_used_size():
	print("updating real size based on radius ", map_radius)
	var rect = tile_map.get_used_rect()
	var tile_size = Vector2(tile_map.tile_set.tile_size)
	var half_tile_size = tile_size / 2
	#var pos = tile_map.map_to_local(rect.position) - half_tile_size
	#var size = rect.size * tile_map.tile_set.tile_size
	var inset_diff = Vector2(0, (2 * map_radius) * (tile_size.y / 4))

	var real_size = (2 * map_radius + 1) * tile_size - inset_diff
	var real_pos = -(real_size / 2) + tile_size / 2
	#print_debug("real_size ", real_size, "real_pos ", real_pos)


	#var use_pos = real_pos - io
	#var use_size = real_size - 2 * io
	real_used_rect = Rect2(real_pos, real_size)
	print("real_pos ", real_pos)
	print("real_size", real_size)
	print("inset_diff ", inset_diff)
	map_size_changed.emit(real_used_rect)

func update_camera():
	camera.limit_left = real_used_rect.position.x
	camera.limit_right = real_used_rect.position.x + real_used_rect.size.x
	camera.limit_top = real_used_rect.position.y
	camera.limit_bottom = real_used_rect.position.y + real_used_rect.size.y
	camera.position = real_used_rect.position + real_used_rect.size / 2

func _gui_input(event: InputEvent) -> void:
	pass

var pressing_at
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pressing_at = event.position

		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			var drag_distance = pressing_at.distance_to(event.position)
			if drag_distance >= 30:
				return

			var click_position = get_local_mouse_position()
			var map_coords = tile_map.local_to_map(click_position)
			print("clicked at ", map_coords)
			print("window is ", get_viewport().get_window().position)

			set_cell(LAYER_CELLS, map_coords, SOURCE_ID, COORDS_LARVA_CELL)

			#if update_next == 'start':
				#update_next = 'end'
				#path_start = map_coords
			#else:
				#update_next = 'start'
				#path_end = map_coords
#
			#var path = astar.get_point_path(cell_id(path_start), cell_id(path_end))
			#var path_positions = []
			#for p in path:
				#path_positions.append(tile_map.map_to_local(p))
			#$BeeTrail.points = path_positions


const BEE_SPECIES_COMPONENT = preload("res://game/scenes/components/bee_species_component.tscn")

func load_bees():
	tile_map.clear()
	var rng = RandomNumberGenerator.new()
	rng.seed = 1

	var bees_to_distribute = BeeSpeciesManager.SPECIES.values()

	for cx in 9:
		for cy in 20:
			var map_coord = Vector2i(cx - 1, cy - 1)
			var potential = is_potential_larva(Vector2i(cx, cy))
			var place_larva = potential and rng.randi_range(0, 1) and bees_to_distribute.size()

			var tile_coord = Vector2i(0, 0) if place_larva else Vector2i(1, 0)
			tile_map.set_cell(0, map_coord, 1, tile_coord)

			if place_larva:
				var species = bees_to_distribute.pop_back()
				#tile_map.set_cell(1, tile_coord, 2, Vector2.ZERO, 1)
				var species_component = tile_map.get_cell_alternative_tile(1, map_coord)

				var bee_component = BEE_SPECIES_COMPONENT.instantiate() as BeeSpeciesComponent
				print("spawn ", species, " at ", map_coord)
				bee_component.species = BeeSpeciesManager.create_species(species)
				bee_component.position = tile_map.map_to_local(Vector2i(cx, cy)) - bee_component.get_rect().size / 2
				tile_map.add_child(bee_component)

	#var map_coord = Vector2i(1, 1)
	#var species = BeeSpeciesManager.SPECIES.BLACKSMITH
	#var bee_component = BEE_SPECIES_COMPONENT.instantiate() as BeeSpeciesComponent
	#print("spawn ", species, " at ", map_coord)
	#bee_component.species = BeeSpeciesManager.create_species(species)
	#bee_component.position = tile_map.map_to_local(map_coord) - bee_component.get_rect().size / 2
	#tile_map.add_child(bee_component)

func is_potential_larva(coords: Vector2i) -> bool:
	var inset = floori(coords.y / 6)
	var nx = (coords.x + inset) % 5
	var ny = coords.y % 6

	var is_larva = false
	match ny:
		1:
			is_larva = nx in [0, 1, 3]
		2:
			is_larva = nx in [0, 2, 3]
		4:
			is_larva = nx in [0, 1, 3]
		5:
			is_larva = nx in [1, 3, 4]

	return is_larva

func regenerate_nav():
	astar.clear()

	for cell in tile_map.get_used_cells(0):
		astar.add_point(cell_id(cell), cell, INF if is_larva_cell(cell) else 1)

	for cell in tile_map.get_used_cells(0):
		for neighbour in tile_map.get_surrounding_cells(cell):
			var tile_data = tile_map.get_cell_tile_data(0, neighbour)
			if not tile_data:
				continue

			var neighbour_larva = is_larva_cell(neighbour)
			#if not neighbour_larva:
			astar.connect_points(cell_id(cell), cell_id(neighbour))

func is_larva_cell(cell: Vector2i):
	return tile_map.get_cell_atlas_coords(0, cell) == Vector2i.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func cell_id(point):
	var a = point.x
	var b = point.y
	return (a + b) * (a + b + 1) / 2 + b
