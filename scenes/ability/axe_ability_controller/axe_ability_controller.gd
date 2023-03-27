extends Node

@export var axe_ability_scene: PackedScene

var damage = 10


func _ready():
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground = self.get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var axe_ability_scene_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_ability_scene_instance)
	axe_ability_scene_instance.global_position = player.global_position
	axe_ability_scene_instance.hitbox_component.damage = damage
