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

@onready var left_section_mating: Container = %LeftSectionMating
@onready var left_section_collection: Container = %LeftSectionCollection
@onready var right_section_buttons: Container = %RightSectionButtons
@onready var right_section_output: Container = %RightSectionOutput

func _ready() -> void:
	var left_side_height = min(
		left_section_mating.get_rect().size.y,
		left_section_collection.get_rect().size.y
	) as int
	left_section_mating.custom_minimum_size = Vector2(0, left_side_height)
	left_section_collection.custom_minimum_size = Vector2(0, left_side_height)

	var right_side_height = min(
		right_section_buttons.get_rect().size.y,
		right_section_output.get_rect().size.y
	)
	right_section_buttons.custom_minimum_size = Vector2(0, right_side_height)
	right_section_output.custom_minimum_size = Vector2(0, right_side_height)

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

	on_inputs_changed()

func on_stage_changed(stage: BeeLabModel.Stage) -> void:
	print("stage changed to ", BeeLabModel.Stage.keys()[stage])
	if stage == BeeLabModel.Stage.BREEDING:
		progress_bar.modulate = Color(Color.WHITE, 1)

		left_section_mating.visible = true
		#left_section_mating.modulate = Color(Color.WHITE, 1)
		#left_section_mating.mouse_filter = Control.MOUSE_FILTER_PASS
#
		left_section_collection.visible = false
		#left_section_collection.modulate = Color(Color.WHITE, 0)
		#left_section_collection.mouse_filter = Control.MOUSE_FILTER_IGNORE
#
		right_section_buttons.visible = false
		#right_section_buttons.modulate = Color(Color.WHITE, 0)
		#right_section_buttons.mouse_filter = Control.MOUSE_FILTER_IGNORE
#
		right_section_output.visible = true
		#right_section_output.modulate = Color(Color.WHITE, 1)
		#right_section_output.mouse_filter = Control.MOUSE_FILTER_PASS

	elif stage == BeeLabModel.Stage.COLLECTION:
		left_section_mating.visible = false
		#left_section_mating.modulate = Color(Color.WHITE, 0)
		#left_section_mating.mouse_filter = Control.MOUSE_FILTER_IGNORE
#
		left_section_collection.visible = true
		#left_section_collection.modulate = Color(Color.WHITE, 1)
		#left_section_collection.mouse_filter = Control.MOUSE_FILTER_PASS
#
		right_section_buttons.visible = false
		#right_section_buttons.modulate = Color(Color.WHITE, 0)
		#right_section_buttons.mouse_filter = Control.MOUSE_FILTER_IGNORE
#
		right_section_output.visible = true
		#right_section_output.modulate = Color(Color.WHITE, 1)
		#right_section_output.mouse_filter = Control.MOUSE_FILTER_PASS

	elif stage == BeeLabModel.Stage.IDLE:
		progress_bar.modulate = Color(Color.WHITE, 0)

		left_section_mating.visible = true
		#left_section_mating.modulate = Color(Color.WHITE, 1)
		#left_section_mating.mouse_filter = Control.MOUSE_FILTER_PASS
#
		left_section_collection.visible = false
		#left_section_collection.modulate = Color(Color.WHITE, 0)
		#left_section_collection.mouse_filter = Control.MOUSE_FILTER_IGNORE
#
		right_section_buttons.visible = true
		#right_section_buttons.modulate = Color(Color.WHITE, 1)
		#right_section_buttons.mouse_filter = Control.MOUSE_FILTER_PASS
#
		right_section_output.visible = false
		#right_section_output.modulate = Color(Color.WHITE, 0)
		#right_section_output.mouse_filter = Control.MOUSE_FILTER_IGNORE

	else:
		push_error("unknown stage change: %s (%s)" % [stage, BeeLabModel.Stage.keys()[stage]])

	#var stageLabel = %StageLabel
	#stageLabel.text = BeeLabModel.Stage.keys()[stage]

# Internal events handling

func _on_start_button_pressed() -> void:
	beelab.mate()

func set_bee_1(bee: Bee):
	beelab.set_input(0, bee)
	bee_slot_1.bee = bee
	on_inputs_changed()

func set_bee_2(bee: Bee):
	beelab.set_input(1, bee)
	bee_slot_2.bee = bee
	on_inputs_changed()

func on_inputs_changed():
	start_button.disabled = !(beelab.input_slots.size() == 2 && beelab.input_slots[0] && beelab.input_slots[1])

func add_bee_result(bee: Bee) -> void:
	bee_result_details.text = build_description(bee)

func build_description(bee: Bee) -> String:
	if !bee:
		return "select a bee"

	var desc = bee.chromosome1.species.display_name + "-" + bee.chromosome2.species.display_name

	desc += "\nfertility: %d" % bee.chromosome1.fertility
	desc += "\nlifespan: %d" % bee.chromosome1.lifespan

	return desc


func _on_collect_button_pressed() -> void:
	# TODO: FIX THE COLLECTION:
	# - going back to IDLE does not fix the mate/predict buttons

	print("collect all items")
	for index in beelab.output_slots.size():
		var bee = beelab.output_slots[index] as Bee
		if bee:
			print("collect", bee)
			add_item_to_storage.emit(bee)
	beelab.clear_output()
	#beelab.remove_output(index)
