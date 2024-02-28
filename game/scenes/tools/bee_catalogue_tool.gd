#@tool
extends Control

@onready var grid_container: GridContainer = $GridContainer
const BEE = preload("res://game/scenes/bee.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in grid_container.get_children():
		child.queue_free()

	BeeSpeciesManager.verify_species()

	for species in BeeSpeciesManager.SPECIES.values():
		print(species)
		var base = BeeSpeciesManager.create_base(species)
		var bee_species = base.active_species()

		add_slot(bee_species, false)
		add_slot(bee_species, true)

func add_slot(species: BeeSpecies, crown: bool):
	var container = VBoxContainer.new()
	grid_container.add_child(container)
	container.owner = get_tree().edited_scene_root

	var bee = BEE.instantiate()
	bee.species = species
	bee.color_1 = species.color_1
	bee.show_crown = crown
	container.add_child(bee)
	bee.owner = get_tree().edited_scene_root

	var label = Label.new()
	label.text = species.display_name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container.add_child(label)
	label.owner = get_tree().edited_scene_root

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
