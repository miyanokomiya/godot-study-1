extends Node
class_name AbilityController

@export var executable = false

var quantity = 1
var additional_damage = 1

func increase_quantity(count: int):
	quantity += count


func increase_damage(damage: float):
	additional_damage += damage


func increase_quickness(percent: float):
	pass


func get_ability_name() -> String:
	return ""


func get_cooldown_time() -> float:
	return 0.0


func get_current_cooldown_time() -> float:
	return 0.0
