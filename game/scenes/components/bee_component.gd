@tool
extends Control

@onready var bee_species_component: CenterContainer = %BeeSpeciesComponent

@export var bee: Bee:
	set(value):
		bee = value
		if not is_node_ready():
			await ready

		if value:
			bee_species_component.show()
			bee_species_component.species = bee.active_species()
			bee_species_component.role = bee.role
			tooltip_text = "BEE"
		else:
			bee_species_component.hide()
			tooltip_text = ""

func _make_custom_tooltip(for_text: String) -> Control:
	var panel = PanelContainer.new()
	var label = Label.new()

	var desc = bee.chromosome1.species.display_name + "-" + bee.chromosome2.species.display_name
	desc += "\nrole: %s" % Bee.BeeRoleEnum.keys()[bee.role]
	desc += "\nfertility: %d" % bee.chromosome1.fertility
	desc += "\nlifespan: %d" % bee.chromosome1.lifespan
	label.text = desc
	panel.add_child(label)
	return panel
