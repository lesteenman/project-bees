extends PanelContainer

@export var bee: Bee = null:
	set(value):
		bee = value
		update_bee()

@export var allow_input: bool = true

@onready var bee_texture = $MarginContainer/VBoxContainer/PanelContainer/BeeTexture
@onready var bee_name = $MarginContainer/VBoxContainer/BeeName

signal bee_selected
signal bee_clicked

func update_bee() -> void:
	if bee:
		var texture = bee.get_texture()
		if texture:
			bee_texture.texture = texture

		var display_name = bee.display_name()
		if display_name:
			bee_name.text = display_name
	else:
		bee_texture.texture = null
		bee_name.text = ""
#
func _get_drag_data(at_position: Vector2) -> Variant:
	return bee

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return allow_input && !bee && data.get_type() == "Bee"
#
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	bee = data
	bee_selected.emit(bee)

func _on_margin_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if bee:
			bee_clicked.emit(bee)
			bee = null
