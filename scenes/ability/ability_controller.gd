extends Node
class_name AbilityController

signal upgraded
signal decorator_added(decorator_controller: AbilityControllerDecorator)

@export var spell_ability_resource: SpellAbilityResource
@export var executable = false
@export var item_pickable = false
@export var base_cooldown_time: float = 1
@export var base_damage: float = 1

var quantity = 1

func increase_quantity(count: int):
	quantity += count
	upgraded.emit()


func get_ability_name() -> String:
	return ""


func get_damage() -> float:
	var damage = base_damage
	if !self.has_node("DecoratorContainer"):
		return damage
	
	var decorator_container = self.get_node("DecoratorContainer")
	for child in decorator_container.get_children():
		damage = (child as AbilityControllerDecorator).decorate_damage(damage)
	
	return damage


func get_cooldown_time() -> float:
	var cooldown_time = base_cooldown_time
	if !self.has_node("DecoratorContainer"):
		return cooldown_time
	
	var decorator_container = self.get_node("DecoratorContainer")
	for child in decorator_container.get_children():
		cooldown_time = (child as AbilityControllerDecorator).decorate_cooldown_time(cooldown_time)
	
	return cooldown_time


func get_current_cooldown_time() -> float:
	return 0.0


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
		(child as AbilityControllerDecorator).decorate_ability(ability)


func decorate_on_timeout():
	if !self.has_node("DecoratorContainer"):
		return
	
	var decorator_container = self.get_node("DecoratorContainer")
	for child in decorator_container.get_children():
		(child as AbilityControllerDecorator).decorate_on_timeout(self)
