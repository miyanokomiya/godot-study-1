extends Node
class_name UpgradeManager

@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene
@export var spell_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_sword = preload("res://resources/upgrades/sword.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_double_sword = preload("res://resources/upgrades/double_sword.tres")
var upgrade_great_sword = preload("res://resources/upgrades/great_sword.tres")
var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")
var upgrade_anvil = preload("res://resources/upgrades/anvil.tres")
var upgrade_dagger = preload("res://resources/upgrades/dagger.tres")
var upgrade_dagger_rate = preload("res://resources/upgrades/dagger_rate.tres")
var upgrade_dagger_damage = preload("res://resources/upgrades/dagger_damage.tres")
var upgrade_combustion = preload("res://resources/upgrades/combustion.tres")
var upgrade_combustion_duration = preload("res://resources/upgrades/combustion_duration.tres")
var upgrade_combustion_damage = preload("res://resources/upgrades/combustion_damage.tres")
var upgrade_dash = preload("res://resources/upgrades/dash.tres")
var upgrade_catch_vial = preload("res://resources/upgrades/catch_vial.tres")
var upgrade_boost_damage = preload("res://resources/upgrades/boost_damage.tres")
var upgrade_double_tap = preload("res://resources/upgrades/double_tap.tres")


func _ready():
	upgrade_pool.add_item(upgrade_sword, 10)
	upgrade_pool.add_item(upgrade_axe, 10)
	upgrade_pool.add_item(upgrade_anvil, 10)
	upgrade_pool.add_item(upgrade_dagger, 10)
	upgrade_pool.add_item(upgrade_combustion, 10)
	upgrade_pool.add_item(upgrade_player_speed, 5)
	upgrade_pool.add_item(upgrade_dash, 5)
	upgrade_pool.add_item(upgrade_catch_vial, 5)
	upgrade_pool.add_item(upgrade_boost_damage, 5)
	upgrade_pool.add_item(upgrade_double_tap, 5)
	
	experience_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1,
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, self)


func apply_upgrade_decorator(target_ability: Ability, decorator_ability: AbilityDecorator):
	var has_upgrade = current_upgrades.has(decorator_ability.id)
	if !has_upgrade:
		current_upgrades[decorator_ability.id] = {
			"resource": decorator_ability,
			"quantity": 1,
			"decorate_targets": {
				target_ability.id: {},
			},
		}
	else:
		current_upgrades[decorator_ability.id]["quantity"] += 1
		current_upgrades[decorator_ability.id]["decorate_targets"] = {
			target_ability.id: {},
		}
	
	if decorator_ability.max_quantity > 0:
		var current_quantity = current_upgrades[decorator_ability.id]["quantity"]
		if current_quantity == decorator_ability.max_quantity:
			upgrade_pool.remove_item(decorator_ability)
	
	update_upgrade_pool(decorator_ability)
	GameEvents.emit_ability_upgrade_added(decorator_ability, self)


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if get_upgrade_quantity(chosen_upgrade.id) != 1:
		return
	
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 10)
	elif chosen_upgrade.id == upgrade_dagger.id:
		upgrade_pool.add_item(upgrade_dagger_rate, 10)
		upgrade_pool.add_item(upgrade_dagger_damage, 10)
	elif chosen_upgrade.id == upgrade_sword.id:
		upgrade_pool.add_item(upgrade_sword_damage, 10)
		upgrade_pool.add_item(upgrade_sword_rate, 10)
		upgrade_pool.add_item(upgrade_double_sword, 5)
		upgrade_pool.add_item(upgrade_great_sword, 5)
	elif chosen_upgrade.id == upgrade_combustion.id:
		upgrade_pool.add_item(upgrade_combustion_duration, 10)
		upgrade_pool.add_item(upgrade_combustion_damage, 10)


func pick_upgrades() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades) as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


func pick_initial_weapon():
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	self.add_child(upgrade_screen_instance)
	var chosen_upgrades: Array[AbilityUpgrade] = [upgrade_sword, upgrade_axe, upgrade_dagger, upgrade_anvil, upgrade_combustion]
	chosen_upgrades.shuffle()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades.slice(0, 3))
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func get_upgrade_quantity(id: String) -> int:
	if current_upgrades.has(id):
		return current_upgrades[id]["quantity"]
	else:
		return 0


func on_spell_selected(target_ability: Ability, decorator_ability: AbilityDecorator):
	if !target_ability:
		return
	
	apply_upgrade_decorator(target_ability, decorator_ability)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	if upgrade is AbilityDecorator:
		var spell_screen = spell_screen_scene.instantiate()
		self.add_child(spell_screen)
		var abilities: Array[Ability] = []
		abilities.assign(
			current_upgrades.values()\
				.map(func(value): return value["resource"])\
				.filter(func(value): return value is Ability) as Array[Ability])
		spell_screen.set_spells(abilities)
		spell_screen.spell_selected.connect(on_spell_selected.bind(upgrade))
	else:
		apply_upgrade(upgrade)


func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	self.add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
