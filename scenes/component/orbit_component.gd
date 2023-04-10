extends Node2D

signal finished

@export var duration: float = 6.0
@export var total_rotation_rate: float = 2.0
@export var attraction: float = 0.0

var current_position = Vector2.ZERO
var current_rotation = 0
var base_actor: Node2D
var base_position = Vector2.ZERO


func start(_base_actor: Node2D, _base_position = Vector2.ZERO):
	var parent = get_parent() as Node2D
	if !parent:
		return
	
	base_actor = _base_actor
	base_position = _base_position
	current_position = parent.global_position
	var tween = create_tween()
	tween.tween_method(on_tween, 0.0, total_rotation_rate, duration)
	tween.tween_callback(on_callback)


func get_base_position() -> Vector2:
	if base_actor:
		return base_actor.global_position
	else:
		return base_position


func on_tween(rate: float):
	var parent = get_parent() as Node2D
	if !parent:
		return
	
	var _base_position = get_base_position()
	var next_rotation = TAU * rate
	var r = next_rotation - current_rotation
	var v = parent.global_position - _base_position
	var normalized_v = v.normalized()
	if normalized_v == Vector2.ZERO && attraction < 0:
		normalized_v = Vector2.from_angle(randf_range(0, TAU))
	
	var attracted_v = v - normalized_v * attraction
	var diff = attracted_v.rotated(r) - v
	parent.global_position += diff
	parent.global_rotation += r
	current_rotation = next_rotation


func on_callback():
	finished.emit()
