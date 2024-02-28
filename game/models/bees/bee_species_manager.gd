extends Node

class_name BeeSpeciesManager

static func _static_init():
	verify_species()
	register_crossbreeds()


static func create_base(species: SPECIES) -> Bee:
	var stats = SPECIES_STATS.get(species)

	var bee_species = BeeSpecies.new(
		stats.display_name,
		stats.color_outline,
		stats.color_1,
		stats.color_2,
	)

	var chromosome1 = Chromosome.new(
		bee_species,
		stats.productivity,
		stats.fertility,
		stats.lifespan,
	)
	var chromosome2 = Chromosome.new(
		bee_species,
		stats.productivity,
		stats.fertility,
		stats.lifespan,
	)

	var bee = Bee.new(chromosome1, chromosome2)
	return bee


enum SPECIES {
	COMMON,
	FOREST,
	WATER
}

# All 1-5, for now
const SPECIES_STATS = {
	SPECIES.COMMON: {
		display_name = "common",
		productivity = 2,
		fertility = 3,
		lifespan = 2,
		color_outline = Color.BLACK,
		color_1 = Color(1, 0.9, 1, 1),
		color_2 = Color(0.8, 1, 1, 1),
	},
	SPECIES.FOREST: {
		display_name = "forest",
		productivity = 3,
		fertility = 2,
		lifespan = 3,
		color_outline = Color.GREEN,
		color_1 = Color.WEB_GREEN,
		color_2 = Color.FOREST_GREEN,
	},
	SPECIES.WATER: {
		display_name = "water",
		productivity = 1,
		fertility = 3,
		lifespan = 3,
		color_outline = Color.BLUE,
		color_1 = Color.LIGHT_BLUE,
		color_2 = Color.LIGHT_CYAN,
	}
}

const required_stats = ["display_name", "color_outline", "color_1", "color_2"]
static func verify_species():
	for species in SPECIES.values():
		print("verifying %s" % species)

		if !SPECIES_STATS.has(species):
			push_error("no stats defined for species %s" % species)
			continue

		var stats = SPECIES_STATS[species]
		for stat in required_stats:
			if !stats.has(stat):
				push_error("%s is not defined for species %s" % [stat, species])

		for gene in Chromosome.genes:
			if !stats.has(gene):
				push_error("gene %s is not defined for species %s" % [gene, species])

static func register_crossbreeds():
	pass
