extends AbilityControllerDecorator

@onready var timer = $Timer


func _ready():
	timer.timeout.connect(on_timer_timeout)


func decorate_ability(ability_scene_instance: SpellAbility):
	ability_scene_instance.hitbox_component.damage *= 2


func on_timer_timeout():
	self.queue_free()
