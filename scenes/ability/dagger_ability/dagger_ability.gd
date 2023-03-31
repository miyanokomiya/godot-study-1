extends Node2D

const MAX_RANGE = 100

@onready var hitbox_component = $HitboxComponent


func play_throw(from: Vector2, target_rotation: float):
	self.global_position = from
	self.rotation = target_rotation + PI / 2
	var tween = create_tween()
	tween.tween_property(self, "global_position", from + Vector2.RIGHT.rotated(target_rotation) * MAX_RANGE, 0.4)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_callback(self.queue_free)
