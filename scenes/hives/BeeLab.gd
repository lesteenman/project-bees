extends PanelContainer


@export var beelab: BeeLab
@onready var start_button: Button = $VBoxContainer2/HBoxContainer2/StartButton
@onready var bee_slot_1: PanelContainer = $VBoxContainer2/MarginContainer/HBoxContainer/BeeSlot1
@onready var bee_slot_result: PanelContainer = $VBoxContainer2/MarginContainer/HBoxContainer/BeeSlotResult
@onready var bee_slot_2: PanelContainer = $VBoxContainer2/MarginContainer/HBoxContainer/BeeSlot2

@onready var bee_1_details: Label = $VBoxContainer2/MarginContainer2/HBoxContainer3/Bee1Details
@onready var bee_2_details: Label = $VBoxContainer2/MarginContainer2/HBoxContainer3/Bee2Details
@onready var bee_result_details: Label = $VBoxContainer2/MarginContainer2/HBoxContainer3/BeeResultDetails



func _init():
	# TODO: This should be managed by global state instead
	beelab = BeeLab.new()

	beelab.connect('set_bee_1', set_bee_1)
	beelab.connect('set_bee_2', set_bee_2)
	beelab.connect('set_bee_result', set_bee_result)

func _on_start_button_pressed() -> void:
	print("start the breeding!")
	beelab.breed()

func _on_bee_slot_1_bee_selected(bee: Bee) -> void:
	beelab.bee1 = bee
	set_bee_1(bee)

func set_bee_1(bee: Bee):
	start_button.disabled = !(beelab.bee1 && beelab.bee2)
	bee_1_details.text = build_description(bee)

	bee_slot_1.bee = bee
	bee_slot_1.update_bee()

func _on_bee_slot_2_bee_selected(bee: Bee) -> void:
	beelab.bee2 = bee
	set_bee_2(bee)

func set_bee_2(bee: Bee):
	start_button.disabled = !(beelab.bee1 && beelab.bee2)
	bee_2_details.text = build_description(bee)

	bee_slot_2.bee = bee
	bee_slot_2.update_bee()

func set_bee_result(bee: Bee) -> void:
	bee_result_details.text = build_description(bee)

	bee_slot_result.bee = bee
	bee_slot_result.update_bee()

func build_description(bee: Bee) -> String:
	if !bee:
		return "select a bee"

	var desc = bee.chromosome1.species.display_name + "-" + bee.chromosome2.species.display_name

	desc += "\nfertility: %d" % bee.chromosome1.fertility
	desc += "\nlifespan: %d" % bee.chromosome1.lifespan

	return desc
