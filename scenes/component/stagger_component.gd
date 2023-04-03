extends Node

@export var velocity_component: Node
@export var damage_threshould: float = 1.0
@export var knockback_power: float = 100.0
@export var health_component: Node

@onready var timer = $Timer

var original_disabled = false


func _ready():
	timer.timeout.connect(on_timer_timeout)


func play_stagger(hitbox: HitboxComponent):
	if health_component.is_died():
		return
	
	var beyond_damage = hitbox.damage - damage_threshould
	if beyond_damage < 0:
		return

	original_disabled = velocity_component.disabled
	velocity_component.disabled = true
	var direction = (self.get_parent().global_position - hitbox.global_position).normalized()
	var power = knockback_power * (1 + beyond_damage * 0.05)
	var tween = create_tween()
	tween.tween_method(on_tween, direction * power, Vector2(0, 0), 0.5)
	timer.start()


func on_tween(velocity: Vector2):
	var parent = self.get_parent() as CharacterBody2D
	if !parent:
		return
	
	parent.velocity = velocity
	parent.move_and_slide()


func on_timer_timeout():
	if !original_disabled:
		velocity_component.disabled = false
