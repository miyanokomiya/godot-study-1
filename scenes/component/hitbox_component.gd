extends Area2D
class_name HitboxComponent

@export var status_effects: Array[StatusEffect] = []

var damage = 0


func set_player_pickup_layer(value: bool):
	self.set_collision_layer_value(5, value)


func set_status_effect(value: StatusEffect):
	status_effects.push_back(value)


func get_status_effects():
	return status_effects
