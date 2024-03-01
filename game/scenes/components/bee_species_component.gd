@tool
extends CenterContainer

@onready var texture_head_outline: TextureRect = %HeadOutline
@onready var texture_body_outline: TextureRect = %BodyOutline
@onready var texture_wings_outline: TextureRect = %WingsOutline
@onready var texture_color_1: TextureRect = %Color1
@onready var texture_color_2: TextureRect = %Color2
@onready var crown: TextureRect = %Crown

#var species: BeeSpecies
@export var species: BeeSpecies:
	set(value):
		#print("set the species")
		#individual = value
		species = value
		color_1 = species.color_1
		color_2 = species.color_2
		color_outline = species.color_outline

@export var color_1: Color:
	set(value):
		color_1 = value
		if not is_node_ready():
			await ready

		update_sprite()

@export var color_2: Color:
	set(value):
		color_2 = value
		if not is_node_ready():
			await ready

		update_sprite()

@export var color_outline: Color:
	set(value):
		color_outline = value
		if not is_node_ready():
			await ready

		update_sprite()

@export var show_crown: bool:
	set(value):
		show_crown = value
		if not is_node_ready():
			await ready
		update_sprite()

func update_sprite():
	texture_body_outline.modulate = color_outline
	texture_head_outline.modulate = color_outline
	texture_wings_outline.modulate = color_outline
	texture_color_1.modulate = color_1
	texture_color_2.modulate = color_2
	crown.modulate = Color(1, 1, 1, 1) if show_crown else Color(1, 1, 1, 0)
