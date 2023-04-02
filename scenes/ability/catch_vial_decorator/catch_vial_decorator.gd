extends AbilityControllerDecorator


func decorate_ability(ability_scene_instance: Node2D):
	ability_scene_instance.hitbox_component.set_player_pickup_layer(true)
