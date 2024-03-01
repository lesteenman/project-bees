extends MarginContainer

var dragging_bee: Bee = null

@export var allow_input := true
@export var bee: Bee = null:
	set(value):
		if value != bee:
			bee = value
			updateBee()

@onready var texture_rect = %BeeTexture
@onready var label = %BeeLabel
#@onready var bee_component: Control = %BeeComponent
@onready var bee_holder = %BeeHolder

const BEE_COMPONENT = preload("res://game/scenes/components/bee_component.tscn")

signal bee_removed
signal bee_added

var bee_component

func updateBee() -> void:
	if bee:
		if not bee_component:
			bee_component = BEE_COMPONENT.instantiate()
			bee_holder.add_child(bee_component)

		bee_component.bee = bee
		#var texture = bee.get_texture()
		#if texture:
			#texture_rect.texture = texture

		var display_name = bee.display_name()
		if display_name:
			label.text = display_name
	else:
		texture_rect.texture = null
		label.text = ""
		bee_component.queue_free()
		bee_component = null

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not bee:
		return null

	dragging_bee = bee

	var drag_preview = BEE_COMPONENT.instantiate()
	drag_preview.bee = bee
	#var drag_preview = TextureRect.new()
	#drag_preview.texture = bee.get_texture()

	set_drag_preview(drag_preview);

	bee = null

	return dragging_bee

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return allow_input && !bee && data.get_type() == "Bee"
#
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	bee = data
	bee_added.emit(bee)

func on_drag_successful():
	bee_removed.emit(bee)
	dragging_bee = null

func on_drag_cancelled():
	bee = dragging_bee
	dragging_bee = null

func _notification(notification_type):
	if dragging_bee:
		match notification_type:
			NOTIFICATION_DRAG_END:
				if get_viewport().gui_is_drag_successful():
					self.on_drag_successful()
				else:
					self.on_drag_cancelled()
