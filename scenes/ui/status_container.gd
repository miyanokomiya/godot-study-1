extends Control
class_name StatusContainer

var status_effect_icon_scene = preload("res://scenes/ui/status_effect_icon.tscn")

@onready var grid_container = $GridContainer


func _ready():
	for c in grid_container.get_children():
		c.queue_free()


func set_status_effect(effect: StatusEffect):
	for c in grid_container.get_children():
		if c.name == effect.id:
			return
	
	var status_effect_icon = status_effect_icon_scene.instantiate()
	grid_container.add_child(status_effect_icon)
	status_effect_icon.set_status_effect(effect)
	status_effect_icon.name = effect.id
	effect.quantity_changed.connect(on_quantity_changed.bind(effect))


func on_quantity_changed(effect: StatusEffect):
	for c in grid_container.get_children():
		if c.name == effect.id:
			if effect.quantity > 0:
				c.set_status_effect(effect)
			else:
				c.queue_free()
			
			break
		
