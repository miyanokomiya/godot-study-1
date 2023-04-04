extends Node
class_name StatusEffectComponent

@export var status_effects: Array[StatusEffect] = []


func affect_taken_damage(damage: float) -> float:
	for effect in status_effects:
		if effect.id == "vulnerable":
			damage *= 1.5
			effect.quantity -= 1
			break
	
	clean_effects()
	return damage


func on_taken_damage(damage: float, taken_status_effects: Array[StatusEffect]):
	for effect in taken_status_effects:
		update_status_effect(effect)


func update_status_effect(target: StatusEffect) -> void:
	var index = 0
	for effect in status_effects:
		if effect.id == target.id:
			break
		else:
			index += 1
	
	if index < status_effects.size():
		status_effects[index].quantity += target.quantity
	else:
		status_effects.push_back(target)


func clean_effects():
	status_effects = status_effects.filter(func(e: StatusEffect): return e.quantity > 0)
