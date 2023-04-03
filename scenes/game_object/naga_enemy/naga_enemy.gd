extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var hurtbox_component = $HurtboxComponent
@onready var hit_random_audio_player_component = $HitRandomAudioPlayerComponent
@onready var stagger_component = $StaggerComponent
@onready var health_component = $HealthComponent
@onready var animation_player = $AnimationPlayer


func _ready():
	if stagger_component.is_staggering:
		return
	
	hurtbox_component.hit.connect(on_hit)
	health_component.died.connect(on_died)


func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)


func on_hit(hitbox: HitboxComponent):
	hit_random_audio_player_component.play_random()
	stagger_component.play_stagger(hitbox)


func on_died():
	velocity_component.disabled = true
	animation_player.play("die")
