extends AbilityControllerDecorator

var chance = 0.1


func decorate_ability(ability_scene_instance: SpellAbility):
	ability_scene_instance.hitbox_component.critical_chance += chance
