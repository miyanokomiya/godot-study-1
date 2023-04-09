extends Node
class_name AbilityControllerDecorator

@export var spell_decorator_resource: SpellDecoratorResource


func get_status_effect() -> StatusEffect:
	return null


func get_color() -> Color:
	return Color.html("#000000")


func decorate_ability(ability_scene_instance: SpellAbility):
	pass


func decorate_on_timeout(controller: AbilityController):
	pass


func decorate_damage(damage: float) -> float:
	return damage


func decorate_cooldown_time(cooldown: float) -> float:
	return cooldown
