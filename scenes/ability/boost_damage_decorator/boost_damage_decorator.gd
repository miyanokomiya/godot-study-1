extends AbilityControllerDecorator


func decorate_ability(ability_scene_instance: SpellAbility):
	ability_scene_instance.hitbox_component.damage *= 2
