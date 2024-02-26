extends PanelContainer

signal add_item_to_storage


@export var beelab: BeeLab:
	set(value):
		beelab = value
		value.connect('set_bee_1', set_bee_1)
		value.connect('set_bee_2', set_bee_2)
		value.connect('set_bee_result', set_bee_result)

		set_bee_1(beelab.bee1)
		set_bee_2(beelab.bee2)
		set_bee_result(beelab.bee_result)

var inventory_handler

@onready var start_button: Button = $VBoxContainer2/HBoxContainer2/StartButton
@onready var bee_slot_1: PanelContainer = %BeeSlot1
@onready var bee_slot_result: PanelContainer = %BeeSlotResult
@onready var bee_slot_2: PanelContainer = %BeeSlot2

@onready var bee_1_details: Label = %Bee1Details
@onready var bee_2_details: Label = %Bee2Details
@onready var bee_result_details: Label = %BeeResultDetails

func _ready() -> void:
	bee_slot_1.connect("bee_removed", func(): set_bee_1(null))
	bee_slot_1.connect("bee_added", func(value): set_bee_1(value))

	bee_slot_2.connect("bee_removed", func(): set_bee_2(null))
	bee_slot_2.connect("bee_added", func(value): set_bee_2(value))

	bee_slot_result.connect("bee_removed", func(): set_bee_result(null))
	bee_slot_result.connect("bee_added", func(value): set_bee_result(value))

func _on_start_button_pressed() -> void:
	print("start the breeding!")
	beelab.breed()

func _on_bee_slot_1_bee_selected(bee: Bee) -> void:
	print("on_bee_slot_1_selected", bee)
	beelab.bee1 = bee
	set_bee_1(bee)

# TODO: DRAW OUT HOW THE BEELAB< THE SLOTS AND THE LAB SCENE INTERACT
func set_bee_1(bee: Bee):
	print("set bee 1 to ", bee)
	start_button.disabled = !(beelab.bee1 && beelab.bee2)
	bee_1_details.text = build_description(bee)

	bee_slot_1.bee = bee

func _on_bee_slot_2_bee_selected(bee: Bee) -> void:
	beelab.bee2 = bee
	set_bee_2(bee)

func set_bee_2(bee: Bee):
	print("set bee 2 to ", bee)
	start_button.disabled = !(beelab.bee1 && beelab.bee2)
	bee_2_details.text = build_description(bee)

	bee_slot_2.bee = bee

func set_bee_result(bee: Bee) -> void:
	bee_result_details.text = build_description(bee)
	bee_slot_result.bee = bee

func build_description(bee: Bee) -> String:
	if !bee:
		return "select a bee"

	var desc = bee.chromosome1.species.display_name + "-" + bee.chromosome2.species.display_name

	desc += "\nfertility: %d" % bee.chromosome1.fertility
	desc += "\nlifespan: %d" % bee.chromosome1.lifespan

	return desc

func _on_bee_slot_1_bee_clicked(bee) -> void:
	print("BeeLab: bee slot 1 clicked")
	inventory_handler.return_bee(bee)

func _on_bee_slot_2_bee_clicked(bee) -> void:
	print("BeeLab: bee slot 2 clicked")
	inventory_handler.return_bee(bee)

func _on_bee_slot_result_bee_clicked(bee) -> void:
	print("BeeLab: bee slot result clicked")
	inventory_handler.return_bee(bee)
