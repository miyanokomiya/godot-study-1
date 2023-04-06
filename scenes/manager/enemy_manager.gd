extends Node

const SPAWN_RADIUS = 370

@export var basic_enemy_scene: PackedScene
@export var skeleton_enemy_scene: PackedScene
@export var flying_eye_enemy_scene: PackedScene
@export var naga_enemy_scene: PackedScene
@export var arena_time_manager: Node
@export var disabled: bool = false

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()


func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_dificulty_increased.connect(on_arena_dificulty_increased)


func get_spawn_position() -> Vector2:
	var player = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset = random_direction * 20
		var query_paramters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1)
		var result = self.get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramters)
	
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func on_timer_timeout():
	timer.start()
	
	if disabled:
		return
	
	var player = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	var entities_layer = self.get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_dificulty_increased(arena_dificulty: int):
	var time_off = (0.1 / 12) * arena_dificulty
	time_off = min(time_off, 0.95)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_dificulty == 6:
		enemy_table.add_item(skeleton_enemy_scene, 15)
	elif arena_dificulty == 18:
		enemy_table.add_item(flying_eye_enemy_scene, 8)
	elif arena_dificulty == 48:
		enemy_table.add_item(naga_enemy_scene, 5)
	elif arena_dificulty == 72:
		enemy_table.add_item(naga_enemy_scene, 5)
	elif arena_dificulty == 120:
		enemy_table.add_item(naga_enemy_scene, 20)
