extends Control

@onready var bee_lab = %BeeLab
@onready var bee_inventory = %BeeInventory
@onready var lab_control: VBoxContainer = %LabControl
@onready var main_menu: VBoxContainer = %MainMenu

var screen_size: Rect2
var menu_transition_tween

const MENU_TRANSITION_TIME = 0.3

func _ready():
	var beelab = BeeLabModel.new()
	bee_lab.beelab = beelab

	screen_size = get_viewport_rect()

	bee_lab.connect("add_item_to_storage", bee_inventory.add_item_to_storage)
	bee_lab.inventory_handler = bee_inventory

	get_node("MainMenu/Labs").connect("pressed", navigate_to_lab)
	lab_control.connect("navigate_back", on_navigate_back)

func on_navigate_back():
	print("should navigate back", main_menu.get_transform())

	if menu_transition_tween:
		menu_transition_tween.kill()
	menu_transition_tween = create_tween()
	menu_transition_tween.tween_property(
		main_menu, "position", Vector2.ZERO, MENU_TRANSITION_TIME
	).set_trans(Tween.TRANS_SINE)
	menu_transition_tween.parallel().tween_property(
		lab_control, "position", Vector2(screen_size.size.x, 0), MENU_TRANSITION_TIME
	).set_trans(Tween.TRANS_SINE)

func navigate_to_lab():
	print("should navigate to lab")

	if menu_transition_tween:
		menu_transition_tween.kill()
	menu_transition_tween = create_tween()
	menu_transition_tween.tween_property(
		lab_control, "position", Vector2.ZERO, MENU_TRANSITION_TIME
	).set_trans(Tween.TRANS_SINE)
	menu_transition_tween.parallel().tween_property(
		main_menu, "position", Vector2(-screen_size.size.x, 0), MENU_TRANSITION_TIME
	).set_trans(Tween.TRANS_SINE)

