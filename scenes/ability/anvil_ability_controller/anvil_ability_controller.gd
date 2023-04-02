extends AbilityController

const BASE_RANGE = 100
const BASE_DAMAGE = 14

@export var anvil_ability_scene: PackedScene
@onready var timer = $Timer


func _ready():
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	for i in self.quantity:	
		var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
		var spawn_position = player.global_position + direction * randf_range(0, BASE_RANGE)
		
		var query_paramters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = self.get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramters)
		if !result.is_empty():
			spawn_position = result["position"]
		
		var anvil_ability = anvil_ability_scene.instantiate()
		self.get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
		self.decorate_ability(anvil_ability)
		anvil_ability.global_position = spawn_position
		anvil_ability.hitbox_component.damage = BASE_DAMAGE
