extends Resource
class_name AbilityUpgrade

enum UpgradeRarily {COMMON = 0, UNCOMMON = 1, RARE = 2}

@export var id: String
@export var max_quantity: int
@export var name: String
@export_multiline var description: String
@export var rarity = UpgradeRarily.COMMON
