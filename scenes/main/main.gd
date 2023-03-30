extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://scenes/ui/pose_menu.tscn")


func _ready():
	$%Player.health_component.died.connect(on_player_died)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.add_child(pause_menu_scene.instantiate())
		self.get_tree().root.set_input_as_handled()


func on_player_died():
	var end_screen_scene_instance = end_screen_scene.instantiate()
	self.add_child(end_screen_scene_instance)
	end_screen_scene_instance.set_defeat()
	MetaProgression.save()
