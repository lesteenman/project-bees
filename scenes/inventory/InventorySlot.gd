extends PanelContainer

@export var bee: Bee = null
var reserved: bool:
	set(value):
		setItemReserved(value)

var is_dragging := false

@onready var texture_rect = $MarginContainer/VBoxContainer/TextureRect
@onready var label = $MarginContainer/VBoxContainer/Label
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer

signal bee_removed

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


func setItemReserved(r) -> void:
	if r:
		v_box_container.modulate = Color(1, 1, 1, 0.4)
	else:
		v_box_container.modulate = Color(1, 1, 1, 1)


func _get_drag_data(_at_position: Vector2) -> Variant:
	if reserved:
		return null

	self.reserved = true
	self.is_dragging = true
	var drag_preview = TextureRect.new()
	drag_preview.texture = bee.get_texture()

	set_drag_preview(drag_preview);

	return bee

func on_drag_successful():
	print("bee was dropped off, remove from inv")
	bee_removed.emit(bee)

func on_drag_cancelled():
	print("drag-and-drop cancelled")
	self.reserved = false


func _notification(notification_type):
	if is_dragging:
		match notification_type:
			NOTIFICATION_DRAG_END:
				self.is_dragging = false
				if get_viewport().gui_is_drag_successful():
					self.on_drag_successful()
				else:
					self.on_drag_cancelled()
