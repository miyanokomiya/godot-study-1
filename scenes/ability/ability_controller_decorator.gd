extends Node
class_name AbilityControllerDecorator


func get_timeout() -> float:
	return 0


func get_color() -> Color:
	return Color.html("#000000")


func decorate_ability(ability_scene_instance: SpellAbility):
	pass


func decorate_on_timeout(controller: AbilityController):
	pass
