extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var hurtbox_component = $HurtboxComponent
@onready var stagger_component = $StaggerComponent


func _ready():
	hurtbox_component.hit.connect(on_hit)


func _process(delta):
	if stagger_component.is_staggering:
		return
	
	velocity_component.accelerate_to_player()
	velocity_component.move(self)


func on_hit(hitbox: HitboxComponent):
	stagger_component.play_stagger(hitbox)
