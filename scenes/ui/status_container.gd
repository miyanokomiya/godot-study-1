extends Control
class_name StatusContainer

var status_effect_icon_scene = preload("res://scenes/ui/status_effect_icon.tscn")

@onready var grid_container = $GridContainer


func _ready():
	for c in grid_container.get_children():
		c.queue_free()


func set_status_effect(effect: StatusEffect):
	var status_effect_icon = status_effect_icon_scene.instantiate()
	grid_container.add_child(status_effect_icon)
	effect.quantity_changed.connect(on_quantity_changed.bind(status_effect_icon, effect))
	effect.emptied.connect(on_effect_emptied.bind(status_effect_icon))
	status_effect_icon.set_status_effect(effect)


func on_effect_emptied(node: Node):
	node.queue_free()


func on_quantity_changed(node: Node, effect: StatusEffect):
	node.set_status_effect(effect)
