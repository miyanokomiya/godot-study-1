extends Node2D

@export var color: Color

@onready var sprite_2d = $Sprite2D
@onready var gpu_particles_2d = $GPUParticles2D


func _ready():
	(sprite_2d.material as ShaderMaterial).set_shader_parameter("base_color", color)
	gpu_particles_2d.modulate = color
