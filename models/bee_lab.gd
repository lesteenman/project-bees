extends Node

class_name BeeLab

var bee1: Bee
var bee2: Bee
@export var bee_result: Bee

signal set_bee_1
signal set_bee_2
signal set_bee_result


func breed():
	bee_result = BeeCrossbreedsManager.crossbreed(bee1, bee2)
	#set_bee_1.emit(null)
	#set_bee_2.emit(null)
	set_bee_result.emit(bee_result)

func max_bees() -> int:
	return 2

func select_bee(bee: Bee):
	if !bee1:
		bee1 = bee
	if !bee2:
		bee2 = bee

func deselect_bee(bee: Bee):
	if bee == bee1:
		bee1 = null
	if bee == bee2:
		bee2 = null
