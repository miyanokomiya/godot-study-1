extends Node2D

@export var color: Color

@onready var sprite_2d = $Sprite2D


func _ready():
	(sprite_2d.material as ShaderMaterial).set_shader_parameter("base_color", color)
