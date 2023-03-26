extends Node
class_name VailDropComponent

@export_range(0, 1) var drop_percent: float = 0.5
@export var health_component: Node
@export var vial_scene: PackedScene


func _ready():
	(health_component as HealthComponent).died.connect(on_died)


func on_died():
	if randf() > drop_percent:
		return
	
	if vial_scene == null:
		return
	
	if not self.owner is Node2D:
		return
	
	var spawn_position = (self.owner as Node2D).global_position
	var vial_instance = vial_scene.instantiate() as Node2D
	self.owner.get_parent().add_child(vial_instance)
	vial_instance.global_position = spawn_position
