extends PanelContainer

@export var bee: Bee = null

@onready var texture_rect = $MarginContainer/VBoxContainer/TextureRect
@onready var label = $MarginContainer/VBoxContainer/Label

signal bee_clicked

func _ready():
	updateBee()

func updateBee() -> void:
	if bee:
		var texture = bee.get_texture()
		if texture:
			texture_rect.texture = texture

		var display_name = bee.display_name()
		if display_name:
			label.text = display_name
	else:
		texture_rect.texture = null
		label.text = ""


func _on_button_pressed() -> void:
	bee_clicked.emit(bee)


func _get_drag_data(_at_position: Vector2) -> Variant:
	var drag_preview = TextureRect.new()
	drag_preview.texture = bee.get_texture()

	set_drag_preview(drag_preview);

	return bee
