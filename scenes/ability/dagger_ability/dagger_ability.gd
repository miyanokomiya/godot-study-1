extends SpellAbility

const MAX_RANGE = 100

@onready var hitbox_component = $HitboxComponent

var current_direction = Vector2.ZERO


func play_throw(from: Vector2, target_rotation: float):
	self.global_position = from
	self.rotation = target_rotation + PI / 2
	var tween = create_tween()
	tween.tween_method(on_tween, Vector2.ZERO, Vector2.RIGHT.rotated(target_rotation) * MAX_RANGE, 0.4)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_callback(self.queue_free)


func on_tween(direction: Vector2):
	var diff = direction - current_direction
	global_position += diff
	current_direction += diff
