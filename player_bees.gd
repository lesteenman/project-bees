extends Node

@export var bees: Array[Bee]

func _ready():
	var bee1 = preload("res://bees/bases/common.tres")
	var bee2 = preload("res://bees/bases/forest.tres")
	
	bees.append(bee1)
	bees.append(bee2)
