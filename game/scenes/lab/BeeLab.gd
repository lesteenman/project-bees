extends PanelContainer

signal add_item_to_storage

@onready var progress_bar: ProgressBar = %ProgressBar

@export var beelab: BeeLabModel:
	set(value):
		beelab = value

		beelab.progress.connect(on_progress)
		beelab.slots_updated.connect(refresh_slots)
		beelab.stage_changed.connect(on_stage_changed)

		refresh_slots()
		on_stage_changed(beelab.stage)

		bee_slot_1.bee_added.connect(set_bee_1)
		bee_slot_1.bee_removed.connect(func(): set_bee_1(null))
		bee_slot_2.bee_added.connect(set_bee_2)
		bee_slot_2.bee_removed.connect(func(): set_bee_2(null))

		#value.connect('set_bee_1', set_bee_1)
		#value.connect('set_bee_2', set_bee_2)

		#set_bee_1(beelab.bee1)
		#set_bee_2(beelab.bee2)

		# TODO: This bit is now incorrect. Should allow setting a queen and changing
		# UI, then finalizing the breeding cycle and adding multiple inventory
		# slots.
		# Means we should also allow a BeeLabModel to define the number of output slots?
		# And when we're at it, might as well make sure that the queen cycle already
		# supports ticks, same as the bee lab!
		#value.connect('add_bee_result', add_bee_result)
		#for result in beelab.bee_results:
			#add_bee_result(beelab.bee_result)

var inventory_handler

@onready var start_button: Button = %StartButton
@onready var bee_slot_1: InventorySlot = %BeeSlot1
@onready var bee_slot_2: InventorySlot = %BeeSlot2
@onready var bee_slot_result_1: InventorySlot = %BeeSlotResult1
@onready var bee_slot_result_2: InventorySlot = %BeeSlotResult2
@onready var bee_slot_result_3: InventorySlot = %BeeSlotResult3

@onready var bee_1_details: Label = %Bee1Details
@onready var bee_2_details: Label = %Bee2Details
@onready var bee_result_details: Label = %BeeResultDetails

func _ready() -> void:
	pass
	#bee_slot_1.connect("bee_removed", func(): set_bee_1(null))
	#bee_slot_1.connect("bee_added", func(value): set_bee_1(value))
#
	#bee_slot_2.connect("bee_removed", func(): set_bee_2(null))
	#bee_slot_2.connect("bee_added", func(value): set_bee_2(value))
#
	#bee_slot_result.connect("bee_removed", func(): set_bee_result(null))
	#bee_slot_result.connect("bee_added", func(value): set_bee_result(value))

#####
# Model signal handling
#####
func on_progress(progress: float) -> void:
	progress_bar.value = progress

func refresh_slots() -> void:
	if beelab.stage == BeeLabModel.Stage.BREEDING:
		bee_slot_1.bee = beelab.queen
		bee_slot_2.bee = null
	else:
		bee_slot_1.bee = beelab.input_slots[0]
		bee_slot_2.bee = beelab.input_slots[1]

	bee_slot_result_1.bee = beelab.output_slots[0]
	bee_slot_result_2.bee = beelab.output_slots[1]
	bee_slot_result_3.bee = beelab.output_slots[2]

func on_stage_changed(stage: BeeLabModel.Stage) -> void:
	var stageLabel = %StageLabel
	stageLabel.text = BeeLabModel.Stage.keys()[stage]

# Internal events handling

func _on_start_button_pressed() -> void:
	print("time to mate, mate!")
	beelab.mate()

func set_bee_1(bee: Bee):
	print("set bee 1 to ", bee)
	beelab.set_input(0, bee)
	#beelab.bee1 = bee

	start_button.disabled = !(beelab.input_slots.size() == 2 && beelab.input_slots[0] && beelab.input_slots[1])
	#bee_1_details.text = build_description(bee)

	bee_slot_1.bee = bee

func set_bee_2(bee: Bee):
	print("set bee 2 to ", bee)
	beelab.set_input(1, bee)
	#beelab.bee2 = bee

	start_button.disabled = !(beelab.input_slots.size() == 2 && beelab.input_slots[0] && beelab.input_slots[1])
	#bee_2_details.text = build_description(bee)

	bee_slot_2.bee = bee

func add_bee_result(bee: Bee) -> void:
	bee_result_details.text = build_description(bee)
	#bee_slot_result.bee = bee

func build_description(bee: Bee) -> String:
	if !bee:
		return "select a bee"

	var desc = bee.chromosome1.species.display_name + "-" + bee.chromosome2.species.display_name

	desc += "\nfertility: %d" % bee.chromosome1.fertility
	desc += "\nlifespan: %d" % bee.chromosome1.lifespan

	return desc
