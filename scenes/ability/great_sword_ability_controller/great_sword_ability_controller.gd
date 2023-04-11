extends AbilityController

const MAX_RANGE = 180

@export var ability_scene: PackedScene


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	$Timer.wait_time = get_cooldown_time()
	$Timer.start()


func get_ability_name() -> String:
	return "G. Sword"


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
	var damage = get_damage()
	var step_rotation = TAU / quantity
	for i in self.quantity:
		var ability_instance = ability_scene.instantiate() as Node2D
		var foreground_layer = self.get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(ability_instance)
		ability_instance.hitbox_component.damage = damage
		var additional_angle = step_rotation * i
		ability_instance.play_throw(player.global_position, enemy_direction.angle() + additional_angle)
		self.decorate_ability(ability_instance)


func on_timer_timeout():
	proc_ability()
	self.decorate_on_timeout()
	$Timer.wait_time = get_cooldown_time()
	$Timer.start()
