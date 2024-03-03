extends Node

var labs: Array[BeeLabModel]

func _ready():
	var beelab = BeeLabModel.new()
	labs.append(beelab)

func _process(delta: float) -> void:
	for lab in labs:
		lab._process(delta)
