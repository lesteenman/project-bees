extends Node

class_name BeeSpeciesManager

static func _static_init():
	verify_species()
	register_crossbreeds()

static func create_species(species: SPECIES) -> BeeSpecies:
	var stats = SPECIES_STATS.get(species)
	return BeeSpecies.new(
		stats.display_name,
		stats.color_outline,
		stats.color_1,
		stats.color_2,
	)

static func create_base(species: SPECIES) -> Bee:
	var stats = SPECIES_STATS.get(species)

	var bee_species = create_species(species)

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
	WORKER,
	SKILLED,
	CARPENTER,
	BLACKSMITH,
	FOREST,
	LAZY,
	ENERGETIC,
	WOODLAND,
	LAKE,
	OCEAN,
	GRASSLANDS,
	POND,
	MEADOWS
}

# All 1-5, for now
const SPECIES_STATS = {
  SPECIES.COMMON: {
	"display_name": "Common",
	"parent_1": SPECIES.FOREST,
	"parent_2": SPECIES.MEADOWS,
	"color_outline": "#7F7F7F",
	"color_1": "#228b22",
	"color_2": "#008000",
	"fertility": 3,
	"productivity": 2,
	"lifespan": 5
  },
  SPECIES.WORKER: {
	"display_name": "Worker",
	"parent_1": SPECIES.POND,
	"parent_2": SPECIES.MEADOWS,
	"color_outline": "#404040",
	"color_1": "#1e90ff",
	"color_2": "#ff8c00",
	"fertility": 2,
	"productivity": 3,
	"lifespan": 4
  },
  SPECIES.SKILLED: {
	"display_name": "Skilled",
	"parent_1": SPECIES.WORKER,
	"parent_2": SPECIES.FOREST,
	"color_outline": "#696969",
	"color_1": "#1e90ff",
	"color_2": "#228b22",
	"fertility": 1,
	"productivity": 4,
	"lifespan": 3
  },
  SPECIES.CARPENTER: {
	"display_name": "Carpenter",
	"parent_1": SPECIES.SKILLED,
	"parent_2": SPECIES.WOODLAND,
	"color_outline": "#3C3C3C",
	"color_1": "#d2691e",
	"color_2": "#228b22",
	"fertility": 4,
	"productivity": 5,
	"lifespan": 2
  },
  SPECIES.BLACKSMITH: {
	"display_name": "Blacksmith",
	"parent_1": SPECIES.SKILLED,
	"parent_2": SPECIES.MEADOWS,
	"color_outline": "#262626",
	"color_1": "#d2691e",
	"color_2": "#008000",
	"fertility": 5,
	"productivity": 2,
	"lifespan": 1
  },
  SPECIES.FOREST: {
	"display_name": "Forest",
	"parent_1": SPECIES.COMMON,
	"parent_2": SPECIES.POND,
	"color_outline": "#262626",
	"color_1": "#228b22",
	"color_2": "#1e90ff",
	"fertility": 2,
	"productivity": 5,
	"lifespan": 3
  },
  SPECIES.LAZY: {
	"display_name": "Lazy",
	"parent_1": SPECIES.MEADOWS,
	"parent_2": SPECIES.POND,
	"color_outline": "#7F7F7F",
	"color_1": "#008000",
	"color_2": "#1e90ff",
	"fertility": 3,
	"productivity": 2,
	"lifespan": 5
  },
  SPECIES.ENERGETIC: {
	"display_name": "Energetic",
	"parent_1": SPECIES.MEADOWS,
	"parent_2": SPECIES.FOREST,
	"color_outline": "#008000",
	"color_1": "#228b22",
	"color_2": "#87ceeb",
	"fertility": 4,
	"productivity": 4,
	"lifespan": 2
  },
  SPECIES.WOODLAND: {
	"display_name": "Woodland",
	"parent_1": SPECIES.FOREST,
	"parent_2": SPECIES.LAZY,
	"color_outline": "#3C3C3C",
	"color_1": "#228b22",
	"color_2": "#008000",
	"fertility": 5,
	"productivity": 3,
	"lifespan": 3
  },
  SPECIES.LAKE: {
	"display_name": "Lake",
	"parent_1": SPECIES.POND,
	"parent_2": SPECIES.LAZY,
	"color_outline": "#008000",
	"color_1": "#1e90ff",
	"color_2": "#87ceeb",
	"fertility": 4,
	"productivity": 3,
	"lifespan": 4
  },
  SPECIES.OCEAN: {
	"display_name": "Ocean",
	"parent_1": SPECIES.POND,
	"parent_2": SPECIES.ENERGETIC,
	"color_outline": "#4D4D4D",
	"color_1": "#1e90ff",
	"color_2": "#228b22",
	"fertility": 5,
	"productivity": 4,
	"lifespan": 1
  },
  SPECIES.GRASSLANDS: {
	"display_name": "Grasslands",
	"parent_1": SPECIES.MEADOWS,
	"parent_2": SPECIES.FOREST,
	"color_outline": "#7F7F7F",
	"color_1": "#228b22",
	"color_2": "#008000",
	"fertility": 3,
	"productivity": 4,
	"lifespan": 3
  },
  SPECIES.POND: {
	"display_name": "Pond",
	"parent_1": SPECIES.MEADOWS,
	"parent_2": SPECIES.LAZY,
	"color_outline": "#4D4D4D",
	"color_1": "#87ceeb",
	"color_2": "#008000",
	"fertility": 4,
	"productivity": 5,
	"lifespan": 2
  },
  SPECIES.MEADOWS: {
	"display_name": "Meadows",
	"parent_1": SPECIES.FOREST,
	"parent_2": SPECIES.POND,
	"color_outline": "#7F7F7F",
	"color_1": "#32cd32",
	"color_2": "#8b4513",
	"fertility": 2,
	"productivity": 3,
	"lifespan": 4
  }
}

const required_stats = ["display_name", "color_outline", "color_1", "color_2"]
static func verify_species():
	for species in SPECIES.values():
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
