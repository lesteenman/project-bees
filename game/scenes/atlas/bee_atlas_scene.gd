extends Node

@export var debug_mode: bool = true

@onready var background: PanelContainer = $PanelContainer

func _ready() -> void:
	%BeeAtlasMap.map_size_changed.connect(update_background_size)
	update_background_size(%BeeAtlasMap.real_used_rect)

func update_background_size(rect: Rect2) -> void:
	background.set_position(rect.position)
	background.set_size(rect.size)
