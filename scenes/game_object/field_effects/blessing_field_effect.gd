extends Node2D

@onready var area_2d = $Area2D


func _ready():
	area_2d.body_entered.connect(on_body_entered)
	area_2d.body_exited.connect(on_body_exited)


func on_body_entered(other_body: Node2D):
	var player = other_body as Player
	if !player:
		return
	
	player.experience_boost = 1.5


func on_body_exited(other_body: Node2D):
	var player = other_body as Player
	if !player:
		return
	
	player.experience_boost = 1.0
