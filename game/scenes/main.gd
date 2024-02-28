extends Control

@onready var bee_lab = %BeeLab
@onready var bee_inventory = %BeeInventory
@onready var lab_control: VBoxContainer = %LabControl
@onready var main_menu: VBoxContainer = %MainMenu


func _ready():
	var beelab = BeeLabModel.new()
	bee_lab.beelab = beelab

	bee_lab.connect("add_item_to_storage", bee_inventory.add_item_to_storage)
	bee_lab.inventory_handler = bee_inventory
