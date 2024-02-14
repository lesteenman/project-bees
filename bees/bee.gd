extends Resource

class_name Bee

@export var type_active: String
@export var type_passive: String

@export var production_rate_active: int
@export var production_rate_passive: int
@export var fertility_active: int
@export var fertility_passive: int


func get_texture() -> Resource:
	return load(BEE_DETAILS[type_active].texture)


func species_name() -> String:
	return BEE_DETAILS[type_active].name



const BEE_DETAILS = {
	"COMMON": {name = "Common Bee", texture = "res://icon.svg"},
	"FOREST": {name = "Forest Bee", texture = "res://icon.svg"},
	"WATER": {name = "Water Bee", texture = "res://icon.svg"}
}
