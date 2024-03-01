@tool
extends Control

@onready var grid_container: GridContainer = $GridContainer
const BEE_COMPONENT = preload("res://game/scenes/components/bee_component.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in grid_container.get_children():
		child.queue_free()

	BeeSpeciesManager.verify_species()

	for species in BeeSpeciesManager.SPECIES.values():

		var drone = BeeSpeciesManager.create_base(species)
		drone.role = Bee.BeeRoleEnum.DRONE

		var princess = BeeSpeciesManager.create_base(species)
		princess.role = Bee.BeeRoleEnum.PRINCESS

		var queen = BeeSpeciesManager.create_base(species)
		queen.role = Bee.BeeRoleEnum.QUEEN

		add_slot(drone)
		add_slot(princess)
		add_slot(queen)

func add_slot(bee: Bee):
	var container = VBoxContainer.new()
	grid_container.add_child(container)
	container.owner = get_tree().edited_scene_root

	var bee_component = BEE_COMPONENT.instantiate()
	bee_component.bee = bee
	#bee.color_1 = species.color_1
	#bee_component.show_crown = crown
	container.add_child(bee_component)
	bee_component.owner = get_tree().edited_scene_root

	var label = Label.new()
	label.text = bee.active_species().display_name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container.add_child(label)
	label.owner = get_tree().edited_scene_root

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
