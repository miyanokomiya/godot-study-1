extends AbilityController

const MAX_RANGE = 180

@export var ability_scene: PackedScene
@onready var decorator_container = $DecoratorContainer


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	$Timer.wait_time = get_cooldown_time()
	$Timer.start()


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
	var damage = get_damage()
	for i in min(self.quantity, enemies.size()):
		var sword_instance = ability_scene.instantiate() as SwordAbility
		foreground_layer.add_child(sword_instance)
		sword_instance.hitbox_component.damage = damage
		sword_instance.global_position = enemies[i].global_position
		sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU))
		var enemy_direction = enemies[i].global_position - sword_instance.global_position
		sword_instance.rotation = enemy_direction.angle()
		self.decorate_ability(sword_instance)


func on_timer_timeout():
	proc_ability()
	self.decorate_on_timeout()
	$Timer.wait_time = get_cooldown_time()
	$Timer.start()
