extends Node2D

@onready var hitbox_component = $HitboxComponent
@onready var particles = $Particles


func play_particles():
	for particle in particles.get_children():
		(particle as GPUParticles2D).emitting = true
