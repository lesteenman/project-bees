extends Node

@export var bees: Array[Bee]

signal refresh_inventory_guis

func _ready():
	var bee1 = BeeSpeciesManager.create_base(BeeSpeciesManager.SPECIES.COMMON)
	var bee2 = BeeSpeciesManager.create_base(BeeSpeciesManager.SPECIES.FOREST)

	bees.append(bee1)
	bees.append(bee2)


func remove_item(bee: Bee):
	bees.erase(bee)


func add_item(bee: Bee):
	bees.append(bee)


func update_inventory():
	refresh_inventory_guis.emit()
