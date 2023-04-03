extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var hit_random_audio_player_component = $HitRandomAudioPlayerComponent
@onready var hurtbox_component = $HurtboxComponent

var is_moving = false


func _ready():
	hurtbox_component.hit.connect(on_hit)


func _process(delta):
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	
	velocity_component.move(self)


func set_is_moving(moving: bool):
	is_moving = moving


func on_hit(hitbox: HitboxComponent):
	hit_random_audio_player_component.play_random()
