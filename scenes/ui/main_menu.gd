extends CanvasLayer

var options_scene = preload("res://scenes/ui/options_menu.tscn")


func _ready():
	$%PlayButton.pressed.connect(on_play_pressed)
	$%UpgradesButton.pressed.connect(on_upgrades_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)


func on_play_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	self.get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_upgrades_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	self.get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")


func on_options_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	var option_instance = options_scene.instantiate()
	self.add_child(option_instance)
	option_instance.back_pressed.connect(on_options_closed.bind(option_instance))


func on_quit_pressed():
	self.get_tree().quit()


func on_options_closed(option_instance: Node):
	option_instance.queue_free()
