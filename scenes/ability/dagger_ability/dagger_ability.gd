extends SpellAbility

const MAX_RANGE = 110

@onready var hitbox_component = $HitboxComponent

var current_distance = 0


func play_throw(from: Vector2, target_rotation: float):
	self.global_position = from
	self.rotation = target_rotation + PI / 2
	var tween = create_tween()
	tween.tween_method(on_tween, 0, MAX_RANGE, 0.4)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_callback(self.queue_free)


func on_tween(distance: float):
	var diff = Vector2.RIGHT.rotated(self.rotation - PI / 2) * (distance - current_distance)
	global_position += diff
	current_distance = distance
