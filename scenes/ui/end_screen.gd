extends CanvasLayer


func _ready():
	self.get_tree().paused = true
	$%RestartButton.pressed.connect(on_restart_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)


func set_defeat():
	$%TitleLabel.text = "Defeat"
	$%DescriptionLabel.text = "You lost!"


func on_restart_button_pressed():
	self.get_tree().paused = false
	self.get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_button_pressed():
	self.get_tree().quit()
