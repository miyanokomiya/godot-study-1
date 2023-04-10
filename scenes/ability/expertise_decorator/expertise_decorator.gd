extends AbilityControllerDecorator


func decorate_cooldown_time(cooldown: float) -> float:
	return cooldown * 0.9


func decorate_ability(ability_scene_instance: SpellAbility):
	ability_scene_instance.hitbox_component.critical_chance += 0.05
