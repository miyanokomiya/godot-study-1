extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var hurtbox_component = $HurtboxComponent
@onready var stagger_component = $StaggerComponent

var is_moving = false


func _ready():
	hurtbox_component.hit.connect(on_hit)


func _process(delta):
	if stagger_component.is_staggering:
		return
	
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	
	velocity_component.move(self)


func set_is_moving(moving: bool):
	is_moving = moving


func on_hit(hitbox: HitboxComponent):
	stagger_component.play_stagger(hitbox)
