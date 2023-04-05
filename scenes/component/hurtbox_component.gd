extends Area2D
class_name HurtboxComponent

signal hit(hitbox: HitboxComponent)

@export var health_component: HealthComponent
@export var status_effect_component: StatusEffectComponent

var floating_text_scene = preload("res://scenes/ui/floating_text.tscn")


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	var hitbox_component = other_area as HitboxComponent
	var damage = hitbox_component.damage
	if status_effect_component:
		damage = status_effect_component.affect_taken_damage(damage)
	
	health_component.damage(damage)
	
	var floating_text = floating_text_scene.instantiate() as Node2D
	self.get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = self.global_position + (Vector2.UP * 16)
	var format_string = "%0.1f"
	if round(damage) == damage:
		format_string = "%0.0f"
	floating_text.start(format_string % damage)
	
	if status_effect_component:
		status_effect_component.on_taken_damage(damage, hitbox_component.get_status_effects())
	
	hit.emit(hitbox_component)
