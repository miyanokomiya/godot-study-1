extends Node
class_name AbilityController

signal upgraded
signal decorator_added(decorator_controller: AbilityControllerDecorator)

@export var executable = false
@export var item_pickable = false
@export var icon: Texture

var quantity = 1
var additional_damage = 0

func increase_quantity(count: int):
	quantity += count
	upgraded.emit()


func increase_damage(damage: float):
	additional_damage += damage
	upgraded.emit()


func increase_quickness(percent: float):
	pass


func get_ability_name() -> String:
	return ""


func get_cooldown_time() -> float:
	return 0.0


func get_current_cooldown_time() -> float:
	return 0.0


func apply_current_upgrades(upgrade_manager: UpgradeManager):
	pass


func proc_ability():
	pass


func add_decorator(decorator_controller: AbilityControllerDecorator):
	if !self.has_node("DecoratorContainer"):
		return
	
	self.get_node("DecoratorContainer").add_child(decorator_controller)
	decorator_added.emit(decorator_controller)


func decorate_ability(ability: Node2D):
	if !self.has_node("DecoratorContainer"):
		return
	
	var decorator_container = self.get_node("DecoratorContainer")
	for child in decorator_container.get_children():
		child.decorate_ability(ability)


func decorate_on_timeout():
	if !self.has_node("DecoratorContainer"):
		return
	
	var decorator_container = self.get_node("DecoratorContainer")
	for child in decorator_container.get_children():
		child.decorate_on_timeout(self)
