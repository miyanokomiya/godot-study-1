extends Node

const SPAWN_RADIUS = 370

@export var basic_enemy_scene: PackedScene
@export var mushroom_enemy_scene: PackedScene
@export var skeleton_enemy_scene: PackedScene
@export var flying_eye_enemy_scene: PackedScene
@export var naga_enemy_scene: PackedScene
@export var naga_blue_enemy_scene: PackedScene
@export var naga_magma_enemy_scene: PackedScene
@export var reptile_enemy_scene: PackedScene
@export var reptile_red_enemy_scene: PackedScene
@export var arena_time_manager: Node
@export var disabled: bool = false

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()


func _ready():
	enemy_table.add_item(mushroom_enemy_scene, 5)
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


func proc_spawn(src: PackedScene, count = 1):
	var entities_layer = self.get_tree().get_first_node_in_group("entities_layer")
	var base_position = get_spawn_position()
	
	for i in count:
		var enemy = src.instantiate() as Node2D
		entities_layer.add_child(enemy)
		enemy.global_position = base_position
		# enemy.global_position = base_position + Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(0, 5 * count)


func on_timer_timeout():
	timer.start()
	
	if disabled:
		return
	
	var player = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	proc_spawn(enemy_table.pick_item())


func on_arena_dificulty_increased(arena_dificulty: int):
	var time_off = (0.1 / 12) * arena_dificulty
	time_off = min(time_off, 0.75)
	timer.wait_time = base_spawn_time - time_off
	
	printt("arena_dificulty:", arena_dificulty)
	if arena_dificulty == 6:
		enemy_table.add_item(skeleton_enemy_scene, 1)
	elif arena_dificulty == 18:
		enemy_table.add_item(skeleton_enemy_scene, 10)
		enemy_table.add_item(flying_eye_enemy_scene, 3)
	elif arena_dificulty == 30:
		proc_spawn(naga_enemy_scene, 2)
		proc_spawn(naga_enemy_scene, 2)
	elif arena_dificulty == 48:
		enemy_table.add_item(naga_enemy_scene, 5)
		enemy_table.add_item(flying_eye_enemy_scene, 10)
		proc_spawn(naga_blue_enemy_scene, 2)
	elif arena_dificulty == 80:
		enemy_table.add_item(naga_enemy_scene, 5)
		enemy_table.add_item(flying_eye_enemy_scene, 10)
		enemy_table.add_item(naga_blue_enemy_scene, 2)
	elif arena_dificulty == 100:
		enemy_table.add_item(naga_enemy_scene, 20)
		enemy_table.add_item(naga_blue_enemy_scene, 5)
	elif arena_dificulty == 120:
		enemy_table.add_item(naga_blue_enemy_scene, 30)
		enemy_table.add_item(reptile_enemy_scene, 5)
		proc_spawn(naga_magma_enemy_scene, 2)
		proc_spawn(naga_magma_enemy_scene, 2)
	elif arena_dificulty == 140:
		enemy_table.add_item(reptile_enemy_scene, 40)
		enemy_table.add_item(naga_magma_enemy_scene, 5)
		enemy_table.add_item(reptile_enemy_scene, 30)
		proc_spawn(reptile_red_enemy_scene, 2)
		proc_spawn(reptile_red_enemy_scene, 2)
	elif arena_dificulty == 160:
		enemy_table.add_item(naga_magma_enemy_scene, 50)
		enemy_table.add_item(reptile_red_enemy_scene, 5)
	elif arena_dificulty == 180:
		enemy_table.add_item(reptile_red_enemy_scene, 100)
