extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var hit_random_audio_player_component = $HitRandomAudioPlayerComponent
@onready var hurtbox_component = $HurtboxComponent


func _ready():
	hurtbox_component.hit.connect(on_hit)


func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)


func on_hit(hitbox: HitboxComponent):
	hit_random_audio_player_component.play_random()
