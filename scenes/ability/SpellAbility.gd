extends Node2D
class_name SpellAbility


func set_status_effect(value: StatusEffect):
	var hitbox_component = get_hitbox_component()
	if hitbox_component:
		hitbox_component.set_status_effect(value)


func get_hitbox_component() -> HitboxComponent:
	for c in self.get_children():
		if c is HitboxComponent:
			return c
	
	return
