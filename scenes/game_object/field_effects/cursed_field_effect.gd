extends Node2D

@export var expand_duration: float = 60 * 8
@export var final_scale: float = 3.4


func _ready():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * final_scale, expand_duration)
