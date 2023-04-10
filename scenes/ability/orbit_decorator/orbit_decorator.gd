extends AbilityControllerDecorator

var orbit_component_scene = preload("res://scenes/component/orbit_component.tscn")


func decorate_ability(ability_scene_instance: SpellAbility):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !player:
		return
	
	var orbit_component = orbit_component_scene.instantiate() as Node2D
	ability_scene_instance.add_child(orbit_component)
	orbit_component.start(player)
