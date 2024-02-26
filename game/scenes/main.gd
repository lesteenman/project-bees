extends Control

@onready var bee_lab: PanelContainer = $BeeLab
@onready var bee_inventory: PanelContainer = %BeeInventory

func _ready():
	var beelab = BeeLab.new()
	bee_lab.beelab = beelab

	bee_lab.connect("add_item_to_storage", bee_inventory.add_item_to_storage)
	bee_lab.inventory_handler = bee_inventory
