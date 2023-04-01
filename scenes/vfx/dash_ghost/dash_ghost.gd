extends Sprite2D

func _ready():
	var tween = create_tween()
	tween.tween_property(self, "material:shader_parameter/alpha", 0.0, 0.3)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_callback(self.queue_free)
