extends PanelContainer

@export var bee: Bee = null
@export var allow_input: bool = true

@onready var bee_texture = $MarginContainer/VBoxContainer/PanelContainer/BeeTexture
@onready var bee_name = $MarginContainer/VBoxContainer/BeeName

signal bee_selected

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

func _get_drag_data(_at_position: Vector2) -> Variant:
	var drag_preview = TextureRect.new()
	drag_preview.texture = bee.get_texture()

	set_drag_preview(drag_preview);

	return bee

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return allow_input && !bee && data.get_type() == "Bee"

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	bee = data
	bee_selected.emit(bee)
	update_bee()
