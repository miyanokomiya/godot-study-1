class_name RarityTable

enum Rarity {COMMON = 0, UNCOMMON = 1, RARE = 2}

var items: Array[Dictionary] = []
var offset = -5
var rare_percent = 3
var uncommon_percent = 37


func add_item(item, rarity: Rarity):
	items.append({ "item": item, "rarity": rarity })


func remove_item(item_to_remove):
	items = items.filter(func(item): return item["item"] != item_to_remove)


func pick_item(exclude: Array = []):
	var adjusted_items: Array[Dictionary] = []
	var weight_rare = get_weight(Rarity.RARE)
	var weight_uncommon = get_weight(Rarity.UNCOMMON)
	var weight_common = get_weight(Rarity.COMMON)
	
	var total_weight = 0
	for item in items:
		if item["item"] in exclude:
			continue
		
		var rarity = item["rarity"]
		var weight = weight_common
		if rarity == Rarity.RARE:
			weight = weight_rare
		elif rarity == Rarity.UNCOMMON:
			weight = weight_uncommon
		
		adjusted_items.append({ "item": item, "rarity": rarity, "weight": weight })
		total_weight += weight
	
	var chosen_weight = randi_range(1, total_weight)
	var iteration_sum = 0
	var chosen
	for item in adjusted_items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			chosen = item["item"]
			break
	
	var chosen_rarity = chosen["rarity"]
	if chosen_rarity == Rarity.COMMON:
		offset += 1
	else:
		offset = -5
	
	return chosen["item"]


func get_weight(rarity: Rarity) -> int:
	var rare = min(max(rare_percent + offset, 0), 40)
	
	var uncommon = uncommon_percent
	if offset < 0:
		uncommon -= offset
	
	var common = 100 - rare - uncommon
	
	match rarity:
		Rarity.RARE:
			return rare
		Rarity.UNCOMMON:
			return uncommon
		_:
			return common
