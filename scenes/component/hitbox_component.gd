extends Area2D
class_name HitboxComponent

signal hit

@export var status_effects: Array[StatusEffect] = []

var damage = 0
var critical_chance = 0.0
var critical_damage_rate = 2.0


func set_player_pickup_layer(value: bool):
	self.set_collision_layer_value(5, value)


func set_status_effect(value: StatusEffect):
	status_effects.push_back(value)


func get_status_effects():
	return status_effects


func get_final_damage(is_critical = false) -> float:
	if is_critical:
		return damage * critical_damage_rate
	else:
		return damage


func rand_critical() -> bool:
	return randf() < critical_chance
