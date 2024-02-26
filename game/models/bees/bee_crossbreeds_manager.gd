extends Resource

class_name BeeCrossbreedsManager

static func crossbreed(bee1: Bee, bee2: Bee) -> Bee:
	# TODO: Attempt mutation
	var parent1 = bee1
	var parent2 = bee2

	var genes: Array[String] = ["species"]
	genes.append_array(Chromosome.genes)

	var builder1 = ChromosomeBuilder.new(genes)
	var builder2 = ChromosomeBuilder.new(genes)

	for gene in genes:
		var alleles = punnet(gene, parent1, parent2)
		builder1.add_allele(gene, alleles[0])
		builder2.add_allele(gene, alleles[1])

	return Bee.new(builder1.build(), builder2.build())


static func punnet(gene: String, parent1: Bee, parent2: Bee):
	var first_choice
	if randf() > 0.5:
		first_choice = parent1.chromosome1
	else:
		first_choice = parent1.chromosome2

	var second_choice
	if randf() > 0.5:
		second_choice = parent2.chromosome1
	else:
		second_choice = parent2.chromosome2

	if randf() > 0.5:
		return [
			first_choice.get(gene),
			second_choice.get(gene)
		]
	else:
		return [
			second_choice.get(gene),
			first_choice.get(gene)
		]

class ChromosomeBuilder:
	var genes: Array[String]
	var alleles: Dictionary

	func _init(g: Array[String]):
		self.genes = g
		self.alleles = {}

	func add_allele(gene: String, value: Variant):
		self.alleles[gene] = value

	func build() -> Chromosome:
		# TODO: Verify all genes have been picked

		return Chromosome.new(
			alleles.get('species'),
			alleles.get('productivity'),
			alleles.get('fertility'),
			alleles.get('lifespan')
		)
