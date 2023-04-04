extends Node

@export var damage_threshould: float = 1.0
@export var knockback_power: float = 60.0
@export var health_component: Node

@onready var stagger_timer = $StaggerTimer
@onready var recover_timer = $RecoverTimer

var SAFETY_RADIAN = PI / 3

var accumulated = 0.0
var is_staggering = false


func _ready():
	stagger_timer.timeout.connect(on_stagger_timer_timeout)
	recover_timer.timeout.connect(on_recover_timer_timeout)


func play_stagger(hitbox: HitboxComponent):
	if health_component.is_died():
		return
	
	accumulated += hitbox.damage
	var beyond_damage = accumulated - damage_threshould
	if beyond_damage < 0:
		return

	accumulated = 0
	var direction = get_stagger_direction(hitbox.global_position)
	var power = knockback_power
	var tween = create_tween()
	tween.tween_method(on_tween, direction * power, Vector2(0, 0), 0.5)
	is_staggering = true
	stagger_timer.start()


func get_stagger_direction(hit_position: Vector2) -> Vector2:
	var self_position = self.get_parent().global_position as Vector2
	var direction = (self_position - hit_position).normalized()
	
	var player = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return direction
	
	var player_direction: Vector2 = (player.global_position - self_position).normalized()
	var angle_diff = player_direction.angle_to(direction)
	if abs(angle_diff) > SAFETY_RADIAN:
		return direction
	
	if angle_diff > 0:
		return direction.rotated(SAFETY_RADIAN - angle_diff)
	else:
		return direction.rotated(-SAFETY_RADIAN - angle_diff)


func on_tween(velocity: Vector2):
	var parent = self.get_parent() as CharacterBody2D
	if !parent:
		return
	
	parent.velocity = velocity
	parent.move_and_slide()


func on_stagger_timer_timeout():
	is_staggering = false


func on_recover_timer_timeout():
	accumulated = max(accumulated - 1, 0)
