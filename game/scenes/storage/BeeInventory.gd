extends PanelContainer

@onready var inventory_grid = $MarginContainer/InventoryGrid
const INVENTORY_SLOT = preload("res://game/scenes/storage/inventory_slot_component.tscn")

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
		inventory_grid.add_child(slot)

		slots.append(slot)
		if PlayerBees.bees.size() > s:
			slot.bee = PlayerBees.bees[s]

		slot.connect("bee_removed", _on_bee_removed)
		slot.connect("bee_added", func(bee): PlayerBees.add_item(bee))

func add_item_to_storage(item):
	match item.get_type():
		"Bee":
			add_bee_to_storage(item)
		_:
			push_error("unrecognized item added to inventory ", item, typeof(item), item.get_type())

func add_bee_to_storage(bee: Bee):
	PlayerBees.add_item(bee)
	for s in slots:
		if not s.bee:
			print("add to slot ", s)
			s.bee = bee

func _on_bee_removed(bee: Bee):
	PlayerBees.remove_item(bee)
