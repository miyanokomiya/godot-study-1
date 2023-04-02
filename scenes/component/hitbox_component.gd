extends Area2D
class_name HitboxComponent

var damage = 0


func set_player_pickup_layer(value: bool):
	self.set_collision_layer_value(5, value)
