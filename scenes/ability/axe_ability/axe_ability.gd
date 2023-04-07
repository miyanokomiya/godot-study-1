extends SpellAbility

const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent

var base_rotation = Vector2.RIGHT
var base_rotation_range = TAU
var base_position = Vector2(100, 100)


func _ready():
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 1.0, 1.5)
	tween.tween_callback(self.queue_free)


func tween_method(rate: float):
	var rotations = base_rotation_range * rate
	var current_radius = rate * MAX_RADIUS + 5
	var current_direction = base_rotation.rotated(rotations)
	
	var player = self.get_tree().get_first_node_in_group("player") as Node2D
	if player != null:
		base_position = player.global_position
	
	self.global_position = base_position + (current_direction * current_radius)
