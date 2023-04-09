extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D

@onready var animation_player = $AnimationPlayer
@onready var gpu_particles_2d = $GPUParticles2D


func _ready():
	gpu_particles_2d.texture = sprite.texture
	health_component.died.connect(on_died)


func on_died():
	if self.owner == null || not self.owner is Node2D:
		return
	
	var spawn_posiiton = self.owner.global_position
	var entities = self.get_tree().get_first_node_in_group("entities_layer")
	self.get_parent().remove_child(self)
	entities.add_child(self)
	self.global_position = spawn_posiiton
	animation_player.play("default")
