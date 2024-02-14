extends PanelContainer

@onready var inventory_grid = $MarginContainer/InventoryGrid
const INVENTORY_SLOT = preload("res://inventory/InventorySlot.tscn")


func _on_ready():
	print("should set slots to contents of player inventory, which is", PlayerBees.bees)

	updateGrid()
		
		
func updateGrid():
	for child in inventory_grid.get_children():
		child.queue_free()
	
	var required_rows: float = (float(PlayerBees.bees.size()) + 1.0) / inventory_grid.columns
	var total_slots = ceil(required_rows) * inventory_grid.columns
	print("should render ", total_slots, " slots in total: ceil(", required_rows, ") * ", inventory_grid.columns)
	print("ceil comes out at ", ceil((PlayerBees.bees.size() + 1) / inventory_grid.columns))
		
	for s in range(total_slots):
		var slot = INVENTORY_SLOT.instantiate()
		if PlayerBees.bees.size() > s:
			slot.bee = PlayerBees.bees[s]
			
		print("added a slot:", slot, slot.bee)
		inventory_grid.add_child(slot)
