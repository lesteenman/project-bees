extends Resource

class_name BeeSpecies

@export var species: BeeSpeciesManager.SPECIES
@export var display_name: String
@export var color_outline: Color
@export var color_1: Color
@export var color_2: Color

func _init(s: BeeSpeciesManager.SPECIES, n: String, co: Color, c1: Color, c2: Color):
	self.species = s
	self.display_name = n
	self.color_outline = co
	self.color_1 = c1
	self.color_2 = c2
