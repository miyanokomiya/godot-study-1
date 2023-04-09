extends AbilityController

@export var ability_scene: PackedScene

var base_damage = 20


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
	
	var direction = Vector2(sign(player.velocity_component.velocity.x), 0)
	if direction.x == 0:
		direction.x = 1
	
	var foreground_layer = self.get_tree().get_first_node_in_group("foreground_layer")
	var sword_instance = ability_scene.instantiate() as SwordAbility
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = self.base_damage + self.additional_damage
	sword_instance.global_position = player.global_position + direction * 30
	sword_instance.scale = Vector2(4, 4)
	sword_instance.scale.x *= direction.x
	self.decorate_ability(sword_instance)
	
	if self.quantity >= 2:
		var step_direction = direction * Vector2(-1, 1)
		var sword_instance2 = ability_scene.instantiate() as SwordAbility
		foreground_layer.add_child(sword_instance2)
		sword_instance2.hitbox_component.damage = self.base_damage + self.additional_damage
		sword_instance2.global_position = player.global_position + step_direction * 30
		sword_instance2.scale = Vector2(4, 4)
		sword_instance2.scale.x *= step_direction.x
		self.decorate_ability(sword_instance2)


func on_timer_timeout():
	proc_ability()
	self.decorate_on_timeout()
	$Timer.wait_time = get_cooldown_time()
	$Timer.start()
