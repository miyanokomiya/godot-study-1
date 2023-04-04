extends AbilityControllerDecorator


func decorate_on_timeout(controller: AbilityController):
	await self.get_tree().create_timer(0.2).timeout
	controller.proc_ability()


func decorate_ability(ability_scene_instance: SpellAbility):
	ability_scene_instance.hitbox_component.damage *= 0.6
