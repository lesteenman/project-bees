extends Resource

class_name Bee

@export var chromosome1: Chromosome
@export var chromosome2: Chromosome

func _init(c1: Chromosome, c2: Chromosome):
	self.chromosome1 = c1
	self.chromosome2 = c2

func get_texture() -> Texture2D:
	return load("res://game/assets/icon.svg")

func display_name() -> String:
	return chromosome1.species.display_name

func active_species() -> BeeSpecies:
	return chromosome1.species

func get_type() -> String:
	return "Bee"
