extends PanelContainer

@onready var inventory_grid = $MarginContainer/InventoryGrid
const INVENTORY_SLOT = preload("res://scenes/inventory/InventorySlot.tscn")

var bees_target
var selected = false
var slots = []

func _on_ready():
	print("should set slots to contents of player inventory, which is", PlayerBees.bees)

	PlayerBees.refresh_inventory_guis.connect(updateGrid)
	updateGrid()

func updateGrid():
	slots.clear()
	for child in inventory_grid.get_children():
		child.queue_free()

	var required_rows: float = (float(PlayerBees.bees.size()) + 1.0) / inventory_grid.columns
	var total_slots = ceil(required_rows) * inventory_grid.columns
	print("should render ", total_slots, " slots in total: ceil(", required_rows, ") * ", inventory_grid.columns)

	for s in range(total_slots):
		var slot = INVENTORY_SLOT.instantiate()
		slots.append(slot)
		if PlayerBees.bees.size() > s:
			slot.bee = PlayerBees.bees[s]

		slot.connect("bee_removed", _on_bee_removed)

		#print("added a slot:", slot, slot.bee)
		inventory_grid.add_child(slot)

func return_bee(bee: Bee):
	print("BeeInventory > should return bee to its slot", bee)
	PlayerBees.add_item(bee)
	for s in slots:
		if s.bee == bee:
			print("return to slot ", s)
			s.setItemReserved(false)

func set_target(target):
	self.bees_target = target

func _on_bee_removed(bee: Bee):
	print("bee removed: ", bee)
	PlayerBees.remove_item(bee)
