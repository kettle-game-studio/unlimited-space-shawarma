extends Resource
class_name Recipe

@export var input: Array[ItemData]
@export var output: Array[ItemData]

static func find_recipe(slots: Array[ItemInMachine], r: Array[Recipe]) -> Recipe:
	var longest_recipe = null
	var length = -1
	for recipe in r:
		if check_recipe(slots, recipe) && recipe.input.size() > length:
			longest_recipe = recipe
			length = recipe.input.size()
	return longest_recipe

static func check_recipe(slots: Array[ItemInMachine], recipe: Recipe) -> bool:
	var slots_items: Array[ItemData] = []
	for slot in slots:
		if slot.item:
			slots_items.push_back(slot.item.item_data)
	for item in recipe.input:
		if !has_enough(slots_items, recipe.input, item):
			return false
	for item in slots_items:
		if !has_enough(recipe.input, slots_items, item):
			return false
	return true

static func has_enough(slots: Array[ItemData], recipe: Array[ItemData], item: ItemData) -> bool:
	var count_in_recipe = 0
	for i in recipe:
		if i.item_name == item.item_name:
			count_in_recipe += 1
			
	var count_on_table = 0
	for s in slots:
		if s && s.item_name == item.item_name:
			count_on_table += 1
	
	# print("item = ", item.item_name)
	# print("count_in_recipe = ", count_in_recipe)
	# print("count_on_table = ", count_on_table)
	return count_in_recipe == count_on_table
