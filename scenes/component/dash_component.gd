extends Node2D

signal finished

var dash_ghost_scene = preload("res://scenes/vfx/dash_ghost/dash_ghost.tscn")

@onready var duration_timer = $DurationTimer
@onready var ghost_timer = $GhostTimer
@onready var cooldown_timer = $CooldownTimer

@export var cooldown_time: float = 1

var target_node: Node2D
var sprite: Sprite2D
var dash_flag = false
var cooldown_flag = false


func _ready():
	duration_timer.timeout.connect(on_duration_timer_timeout)
	ghost_timer.timeout.connect(on_ghost_timer_timeout)
	cooldown_timer.timeout.connect(on_cooldown_timer)
	
	cooldown_timer.wait_time = cooldown_time


func can_dash() -> bool:
	return !dash_flag && !cooldown_flag


func start_dash(target: Node2D, target_sprite: Sprite2D, duration: float):
	if dash_flag || cooldown_flag:
		return
	
	dash_flag = true
	target_node = target
	sprite = target_sprite
	duration_timer.wait_time = duration
	duration_timer.start()
	ghost_timer.start()


func end_dash():
	dash_flag = false
	ghost_timer.stop()
	cooldown_flag = true
	cooldown_timer.start()
	finished.emit()


func spawn_ghost():
	if !target_node:
		return

	var ghost = dash_ghost_scene.instantiate() as Sprite2D
	self.get_tree().get_first_node_in_group("background_layer").add_child(ghost)
	ghost.global_position = target_node.global_position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	ghost.offset = sprite.offset


func on_duration_timer_timeout():
	end_dash()


func on_ghost_timer_timeout():
	spawn_ghost()


func on_cooldown_timer():
	cooldown_flag = false
