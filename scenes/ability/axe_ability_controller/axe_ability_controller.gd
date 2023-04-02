extends AbilityController

@export var axe_ability_scene: PackedScene

var base_damage = 9


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground = self.get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in self.quantity:
		var axe_ability_scene_instance = axe_ability_scene.instantiate() as Node2D
		foreground.add_child(axe_ability_scene_instance)
		axe_ability_scene_instance.base_rotation = base_rotation.rotated(TAU / self.quantity * i)
		axe_ability_scene_instance.global_position = player.global_position
		axe_ability_scene_instance.hitbox_component.damage = self.base_damage + self.additional_damage
		self.decorate_ability(axe_ability_scene_instance)


func on_ability_upgrade_added(upgrade: AbilityUpgrade, upgrade_manager: UpgradeManager):
	if upgrade.id == "axe_damage":
		self.increase_damage(upgrade_manager.get_upgrade_quantity("axe_damage"))
