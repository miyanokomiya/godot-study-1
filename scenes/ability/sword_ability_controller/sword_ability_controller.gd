extends AbilityController

const MAX_RANGE = 150

@export var ability_scene: PackedScene
@onready var decorator_container = $DecoratorContainer

var base_damage = 5
var base_wait_time


func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = self.get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	if enemies.size() == 0:
		return

	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var foreground_layer = self.get_tree().get_first_node_in_group("foreground_layer")
	for i in min(self.quantity, enemies.size()):
		var sword_instance = ability_scene.instantiate() as SwordAbility
		foreground_layer.add_child(sword_instance)
		self.decorate_ability(sword_instance)
		sword_instance.hitbox_component.damage = self.base_damage + self.additional_damage
		sword_instance.global_position = enemies[i].global_position
		sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU))
		var enemy_direction = enemies[i].global_position - sword_instance.global_position
		sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, upgrade_manager: UpgradeManager):
	if upgrade.id == "sword_rate":
		var reduction = pow(0.9, upgrade_manager.get_upgrade_quantity("sword_rate"))
		$Timer.wait_time = base_wait_time * reduction
		$Timer.start()
	elif upgrade.id == "sword_damage":
		self.increase_damage(upgrade_manager.get_upgrade_quantity("sword_damage"))
	elif upgrade.id == "double_sword":
		self.increase_quantity(self.quantity * 2)
