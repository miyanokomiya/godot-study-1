extends SpellAbility

const MAX_RANGE = 150

@onready var hitbox_component = $HitboxComponent

var current_distance = 0
var self_rotated = 0


func _ready():
	play_throw(self.global_position, 0)


func play_throw(from: Vector2, target_rotation: float):
	self.global_position = from
	self.rotation = target_rotation + PI / 2
	var tween = create_tween()
	tween.tween_method(on_tween, 0, MAX_RANGE, 2).set_ease(Tween.EASE_OUT)
	tween.tween_callback(self.queue_free)
	
	var target_scale = self.scale
	var tween2 = create_tween()
	tween2.tween_property(self, "scale", Vector2.ZERO, 0)
	tween2.tween_property(self, "scale", target_scale, 0.3).set_ease(Tween.EASE_OUT)
	tween2.tween_property(self, "scale", Vector2.ZERO, 0.3).set_ease(Tween.EASE_IN).set_delay(1.4)


func on_tween(distance: float):
	var diff = Vector2.RIGHT.rotated(self.rotation - PI / 2 - self_rotated) * (distance - current_distance)
	global_position += diff
	var rotate_diff = (distance - current_distance) / MAX_RANGE * TAU * 2.5
	rotation += rotate_diff
	self_rotated += rotate_diff
	current_distance = distance
