extends PanelContainer

@export var bee: Bee = null

@onready var texture_rect = $MarginContainer/TextureRect

func _ready():
	updateBee()

func updateBee() -> void:
	print("setting slot bee to", bee)
	
	if bee:
		var texture = bee.get_texture()
		print("bee type", bee.type_active, bee.get_texture())
		if texture and texture_rect:
			texture_rect.texture = texture
			
		var name = bee.species_name()
		if name:
			tooltip_text = name
