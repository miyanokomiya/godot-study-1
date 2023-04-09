extends AbilityController

const MAX_RANGE = 150
const BASE_FIRE_DURATION = 2

@export var ability_scene: PackedScene

var base_damage = 5
var extra_fire_duration = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	$Timer.wait_time = get_cooldown_time()
	$Timer.start()


func get_ability_name() -> String:
	return "Conbust."


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
	
	var foreground_layer = self.get_tree().get_first_node_in_group("foreground_layer")
	for i in min(self.quantity, enemies.size()):
		var ability_instance = ability_scene.instantiate()
		foreground_layer.add_child(ability_instance)
		ability_instance.hitbox_component.damage = self.base_damage + self.additional_damage
		ability_instance.global_position = enemies[i].global_position
		ability_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU))
		ability_instance.set_lifetime(BASE_FIRE_DURATION + extra_fire_duration)
		self.decorate_ability(ability_instance)


func on_timer_timeout():
	proc_ability()
	self.decorate_on_timeout()
	$Timer.wait_time = get_cooldown_time()
	$Timer.start()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, upgrade_manager: UpgradeManager):
	if upgrade.id == "combustion_duration":
		extra_fire_duration = upgrade_manager.get_upgrade_quantity("combustion_duration") * 0.5
	elif upgrade.id == "combustion_damage":
		self.increase_damage(1)
