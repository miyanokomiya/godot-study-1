extends AbilityControllerDecorator

@export var status_effect: StatusEffect


func decorate_ability(ability_scene_instance: SpellAbility):
	ability_scene_instance.set_status_effect(status_effect)
