extends Control

@onready var bee_lab = %BeeLab
@onready var bee_inventory = %BeeInventory
@onready var lab_control: VBoxContainer = %LabControl
@onready var main_menu: VBoxContainer = %MainMenu
@onready var bee_atlas_scene: Control = $BeeAtlasViewportContainer
@onready var header: PanelContainer = %Header

var screen_size: Rect2
var menu_transition_tween
var navigation_stack: Array

const MENU_TRANSITION_TIME = 0.3
const HEADER_TRANSITION_TIME = 0.2

func _ready():
	#var beelab = BeeLabModel.new()
	bee_lab.beelab = LabManager.labs[0]

	navigation_stack = []

	screen_size = get_viewport_rect() as Rect2

	lab_control.position = Vector2(screen_size.size.x, 0)
	bee_atlas_scene.position = Vector2(screen_size.size.x, 0)

	var atlas_viewport = %BeeAtlasViewport as SubViewport
	atlas_viewport.size = screen_size.size

	bee_lab.connect("add_item_to_storage", bee_inventory.add_item_to_storage)
	bee_lab.inventory_handler = bee_inventory

	get_node("MainMenu/Labs").connect("pressed", func(): navigate_forward(lab_control))
	get_node("MainMenu/SpeciesAtlas").connect("pressed", func(): navigate_forward(bee_atlas_scene))

	lab_control.connect("navigate_back", on_navigate_back)

	set_header_visible(false, false)

	var header_margin = %Header/MarginContainer as MarginContainer
	var safe_area = DisplayServer.get_display_safe_area()
	print("Safe area: ", safe_area)
	print("Cutouts: ", DisplayServer.get_display_cutouts())
	var top_margin = safe_area.position.y + 5
	header_margin.add_theme_constant_override("margin_top", top_margin)

func navigate_forward(new_page: Control):
	var previous_page = navigation_stack[navigation_stack.size() - 1] \
		if navigation_stack.size() else main_menu
	navigation_stack.append(new_page)

	set_header_visible(navigation_stack.size() > 0, true)

	if menu_transition_tween:
		menu_transition_tween.kill()
	menu_transition_tween = create_tween()

	menu_transition_tween.tween_property(
		new_page, "position", Vector2.ZERO, MENU_TRANSITION_TIME
	).set_trans(Tween.TRANS_SINE)
	menu_transition_tween.parallel().tween_property(
		previous_page, "position", Vector2(-screen_size.size.x, 0), MENU_TRANSITION_TIME
	).set_trans(Tween.TRANS_SINE)

func on_navigate_back():
	var previous_page = navigation_stack.pop_back()
	var current_page = navigation_stack[navigation_stack.size() - 1] \
		if navigation_stack.size() else main_menu

	set_header_visible(navigation_stack.size() > 0, true)

	print("should navigate back", previous_page, current_page)

	if menu_transition_tween:
		menu_transition_tween.kill()
	menu_transition_tween = create_tween()

	menu_transition_tween.tween_property(
		current_page, "position", Vector2.ZERO, MENU_TRANSITION_TIME
	).set_trans(Tween.TRANS_SINE)
	menu_transition_tween.parallel().tween_property(
		previous_page, "position", Vector2(screen_size.size.x, 0), MENU_TRANSITION_TIME
	).set_trans(Tween.TRANS_SINE)

func set_header_visible(is_visible: bool, animated: bool):
	var tween = create_tween()

	var new_position = Vector2(0, 0 if is_visible else -header.get_rect().size.y)
	tween.tween_property(header, "position", new_position, HEADER_TRANSITION_TIME)
