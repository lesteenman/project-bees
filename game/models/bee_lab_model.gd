extends Node

class_name BeeLabModel

var input_slots: Array[Bee] = []
var output_slots: Array[Bee] = []
var queen: Bee
var stage: Stage = Stage.IDLE
#var bee1: Bee
#var bee2: Bee
#@export var bee_result: Bee

signal slots_updated # on_slots_updated()
signal stage_changed # on_stage_changed(stage: Stage)
signal progress # on_progress(progress: float[0,100])

enum Stage { IDLE, BREEDING }

func _init() -> void:
	input_slots.resize(2)
	input_slots.fill(null)

	output_slots.resize(6)
	output_slots.fill(null)

func _process(delta: float) -> void:
	if queen:
		queen.lifetime += delta
		update_progress()

func set_input(index: int, bee: Bee):
	if index < 0 or index > 1:
		push_error("attempted to set input number %d, must be [0,1]" % index)
		return

	input_slots[index] = bee

func remove_output(index: int, bee: Bee):
	pass

func update_progress():
	var current_progress = min(100.0, (queen.lifetime / queen.get_max_lifetime()) * 100)
	progress.emit(current_progress)
	if current_progress >= 100.0:
		breed()

func mate():
	if input_slots.size() != 2:
		push_error("attempted to mate with %d inputs filled" % input_slots.size())
		return

	var princess = input_slots[0] as Bee
	if princess.role != Bee.BeeRoleEnum.PRINCESS:
		push_error("attempted to mate with a non-princess primary candidate")
		return

	var drone = input_slots[1] as Bee
	if drone.role != Bee.BeeRoleEnum.DRONE:
		push_error("attempted to mate with a non-drone secondary candidate")
		return

	queen = Bee.new(princess.chromosome1, princess.chromosome2)
	#queen = princess.duplicate(true) as Bee
	queen.role = Bee.BeeRoleEnum.QUEEN
	queen.mate = drone
	queen.lifetime = 0

	input_slots.fill(null)
	#input_slots[0] = queen

	stage = Stage.BREEDING
	stage_changed.emit(stage)
	slots_updated.emit()
	update_progress()

func breed():
	# Obviously needs to take offspring into account
	var offspring_count = randi_range(1, 3)
	output_slots.fill(null)
	for i in range(offspring_count):
		var bee_result = BeeCrossbreedsManager.crossbreed(queen, queen.mate)
		if i == 0:
			bee_result.role = Bee.BeeRoleEnum.PRINCESS
		output_slots[i] = bee_result

	queen = null

	slots_updated.emit()

	stage = Stage.IDLE
	stage_changed.emit(stage)

	# TODO: Instead of doing this: Should allow setting a queen and changing
		# UI, then finalizing the breeding cycle and adding multiple inventory
		# slots.
		# Means we should also allow a BeeLabModel to define the number of output slots?
		# And when we're at it, might as well make sure that the queen cycle already
		# supports ticks, same as the bee lab!
	#add_bee_result.emit(bee_result)

#func max_bees() -> int:
	#return 2

#func select_bee(bee: Bee):
	#if !bee1:
		#bee1 = bee
	#if !bee2:
		#bee2 = bee
#
#func deselect_bee(bee: Bee):
	#if bee == bee1:
		#bee1 = null
	#if bee == bee2:
		#bee2 = null
