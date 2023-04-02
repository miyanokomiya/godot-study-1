extends AbilityController

const MAX_RANGE = 150

@export var dagger_ability: PackedScene

var base_damage = 4
var base_wait_time


func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func proc_ability():
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
	
	var enemy = enemies[0]
	var enemy_direction = enemy.global_position - player.global_position
	for i in self.quantity:
		var dagger_instance = dagger_ability.instantiate() as Node2D
		var foreground_layer = self.get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(dagger_instance)
		dagger_instance.hitbox_component.damage = self.base_damage + self.additional_damage
		var additional_angle = ceil(i / 2.0) * deg_to_rad(15.0) * sign((i % 2) * 2 - 1)
		dagger_instance.play_throw(player.global_position, enemy_direction.angle() + additional_angle)
		self.decorate_ability(dagger_instance)


func on_timer_timeout():
	proc_ability()
	self.decorate_on_timeout()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, upgrade_manager: UpgradeManager):
	if upgrade.id == "dagger_rate":
		var reduction = pow(0.9, upgrade_manager.get_upgrade_quantity("dagger_rate"))
		$Timer.wait_time = base_wait_time * reduction
		$Timer.start()
	elif upgrade.id == "dagger_damage":
		self.increase_damage(1)
