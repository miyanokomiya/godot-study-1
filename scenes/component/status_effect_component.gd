extends Node
class_name StatusEffectComponent

@export var status_effects: Array[StatusEffect] = []
@export var status_container: StatusContainer


func affect_taken_damage(damage: float) -> float:
	for effect in status_effects:
		if effect.id == "vulnerable" && effect.quantity > 0:
			damage *= 1.5
			effect.set_quantity(effect.quantity - 1)
			break
	
	clean_effects()
	return damage


func on_taken_damage(damage: float, taken_status_effects: Array[StatusEffect]):
	for effect in taken_status_effects:
		update_status_effect(effect)


func update_status_effect(target: StatusEffect) -> void:
	var index = -1
	for effect in status_effects:
		index += 1
		if effect.id == target.id:
			break
	
	if -1 < index && index < status_effects.size():
		var current = status_effects[index]
		current.set_quantity(current.quantity + target.quantity)
	else:
		var target_uniqued = target.duplicate()
		status_effects.push_back(target_uniqued)
		if status_container:
			status_container.set_status_effect(target_uniqued)


func clean_effects():
	status_effects = status_effects.filter(func(e: StatusEffect): return e.quantity > 0)
