extends AbilityControllerDecorator

@export var ability_scene: PackedScene


func decorate_ability(ability_scene_instance: SpellAbility):
	var hitbox = ability_scene_instance.get_hitbox_component()
	if hitbox:
		hitbox.hit.connect(on_hit.bind(ability_scene_instance), CONNECT_ONE_SHOT)


func on_hit(ability: SpellAbility):
	Callable(on_hit_deferred.bind(ability.global_position)).call_deferred()


func on_hit_deferred(position: Vector2):
	var foreground_layer = self.get_tree().get_first_node_in_group("foreground_layer")
	var ability_instance = ability_scene.instantiate() as Node2D
	foreground_layer.add_child(ability_instance)
	ability_instance.scale *= 0.6
	ability_instance.global_position = position + (Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(0, 16))
	ability_instance.hitbox_component.damage = 3
	ability_instance.set_lifetime(1)
