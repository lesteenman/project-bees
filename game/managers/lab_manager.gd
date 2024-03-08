extends Node

var labs: Array[BeeLabModel]

@export var acceleration_factor = 5

func _ready():
	var beelab = BeeLabModel.new()
	labs.append(beelab)

func _process(delta: float) -> void:
	for lab in labs:
		lab._process(delta * acceleration_factor)
