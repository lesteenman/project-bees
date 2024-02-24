extends Control

@onready var bee_lab: PanelContainer = $BeeLab
@onready var bee_inventory: PanelContainer = $ScrollContainer/BeeInventory

func _ready():
	var beelab = BeeLab.new()
	bee_lab.beelab = beelab

	bee_lab.inventory_handler = bee_inventory
