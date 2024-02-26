extends Resource

class_name Chromosome

@export var species: BeeSpecies
@export var productivity: int
@export var fertility: int
@export var lifespan: int

const genes = ['productivity', 'fertility', 'lifespan']

func _init(sp: BeeSpecies, pr: int, fe: int, li: int):
	self.species = sp
	self.productivity = pr
	self.fertility = fe
	self.lifespan = li
