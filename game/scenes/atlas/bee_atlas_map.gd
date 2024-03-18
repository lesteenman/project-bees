@tool
extends TileMap

class_name BeeAtlasMap

@onready var tile_map: TileMap = %BeeAtlasMap
@onready var astar = AStar2D.new()
@onready var camera: Camera2D = %BeeAtlasCamera

@export var map_radius = 1:
	set(value):
		map_radius = value
		if not is_node_ready():
			await ready
		update_cells()

const COORDS_EMPTY_CELL = Vector2i(1, 0)
const COORDS_LARVA_CELL = Vector2i(0, 0)
const LAYER_CELLS = 0
const SOURCE_ID = 1

var larva_rng = RandomNumberGenerator.new()
var path_start: Vector2i
var path_end: Vector2i
var update_next = 'start'
var real_used_rect = Rect2(Vector2.ZERO, Vector2.ZERO)

var larva_cells = []
var larva_locations = {}
var species_children = []

@export var larva_rng_seed = 7:
	set(value):
		larva_rng_seed = value
		if not is_node_ready():
			await ready
		update_cells()

signal map_size_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	larva_rng.seed = larva_rng_seed
	update_cells()

func update_cells():
	for child in species_children:
		child.queue_free()
	species_children.clear()

	clear_map()
	load_tiles()
	load_bees()
	regenerate_nav()

func clear_map():
	larva_cells.clear()
	tile_map.clear()
	larva_locations.clear()

func load_tiles() -> void:
	for y in range(-map_radius, map_radius + 1):
		var columns = range(-map_radius, map_radius + (1 if (abs(y) % 2) == 0 else 0))
		for x in columns:
			var map_coord = Vector2i(x, y)

			#var larva = is_potential_larva(map_coord)
			tile_map.set_cell(LAYER_CELLS, map_coord, SOURCE_ID, COORDS_EMPTY_CELL)

			var potential = is_potential_larva(map_coord)
			var place_larva = potential and larva_rng.randi_range(0, 4) == 0
			if place_larva:
				larva_cells.append(map_coord)

	larva_cells.sort_custom(func(a, b):
		return (abs(a.x) + abs(a.y)) < (abs(b.x) + abs(b.y))
		)

	update_real_used_size()
	update_camera()

func visualize_spawns():
	#for cell in get_used_cells(LAYER_CELLS):
		#if is_potential_larva(cell):
			#set_cell(LAYER_CELLS, cell, SOURCE_ID, COORDS_LARVA_CELL)

	for cell in larva_cells:
		set_cell(LAYER_CELLS, cell, SOURCE_ID, COORDS_LARVA_CELL)

func update_real_used_size():
	print_debug("updating real size based on radius ", map_radius)
	var tile_size = Vector2(tile_map.tile_set.tile_size)
	var inset_diff = Vector2(0, (2 * map_radius) * (tile_size.y / 4))

	var real_size = (2 * map_radius + 1) * tile_size - inset_diff
	var real_pos = -(real_size / 2) + tile_size / 2

	real_used_rect = Rect2(real_pos, real_size)
	map_size_changed.emit(real_used_rect)

func update_camera():
	camera.limit_left = real_used_rect.position.x
	camera.limit_right = real_used_rect.position.x + real_used_rect.size.x
	camera.limit_top = real_used_rect.position.y
	camera.limit_bottom = real_used_rect.position.y + real_used_rect.size.y
	camera.position = real_used_rect.position + real_used_rect.size / 2

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
			is_potential_larva(map_coords)

const BEE_SPECIES_COMPONENT = preload("res://game/scenes/components/bee_species_component.tscn")

func load_bees():
	var bees_to_distribute = BeeSpeciesManager.SPECIES.values()
	print_debug("distribute ", bees_to_distribute)

	for map_coord in larva_cells:
		if not bees_to_distribute.size():
			break

		tile_map.set_cell(0, map_coord, SOURCE_ID, COORDS_LARVA_CELL)
#
		var species_id = bees_to_distribute.pop_back() as BeeSpeciesManager.SPECIES
		var species = BeeSpeciesManager.create_species(species_id)
		larva_locations[species.species] = map_coord
#
		var tile_component = BEE_SPECIES_COMPONENT.instantiate() as BeeSpeciesComponent
		tile_component.clicked.connect(species_clicked)
		tile_map.add_child(tile_component)
		species_children.append(tile_component)
		tile_component.species = species
		tile_component.position = tile_map.map_to_local(map_coord) - tile_component.get_rect().size / 2

func species_clicked(species: BeeSpecies) -> void:
	print_debug("clicked bee species in atlas: ", species.display_name)

func is_potential_larva(coords: Vector2i) -> bool:
	var offset = posmod(coords.y, 2) * 2
	return posmod(coords.x + offset, 3) == 0

	#var inset = floori((coords.y + 99000.0) / 6)
	#var nx = posmod(coords.x + inset, 5)# % 5
	#var ny = posmod(coords.y, 6)
#
	#var is_larva = false
	#match ny:
		#0:
			#is_larva = nx in [0, 1, 3]
		#1:
			#is_larva = nx in [0, 2, 3]
		#3:
			#is_larva = nx in [0, 1, 3]
		#4:
			#is_larva = nx in [1, 3, 4]
#
	#return is_larva

func regenerate_nav():
	astar.clear()

	for cell in tile_map.get_used_cells(0):
		astar.add_point(cell_id(cell), cell, INF if is_larva_cell(cell) else 1.0)

	for cell in tile_map.get_used_cells(0):
		for neighbour in tile_map.get_surrounding_cells(cell):
			var tile_data = tile_map.get_cell_tile_data(0, neighbour)
			if not tile_data:
				continue

			#var neighbour_larva = is_larva_cell(neighbour)
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
