extends Node

@export var bees: Array[Bee]

func _ready():
	var bee1 = BeeSpeciesManager.create_base(BeeSpeciesManager.SPECIES.COMMON)
	var bee2 = BeeSpeciesManager.create_base(BeeSpeciesManager.SPECIES.FOREST)

	bees.append(bee1)
	bees.append(bee2)
