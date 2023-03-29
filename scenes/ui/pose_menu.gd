extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var panel_container = $MarginContainer/PanelContainer

var options_scene = preload("res://scenes/ui/options_menu.tscn")

var is_closing = false


func _ready():
	self.get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	$%ResumeButton.pressed.connect(on_resume_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)
	
	animation_player.play("default")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		close()
		self.get_tree().root.set_input_as_handled()


func close():
	if is_closing:
		return
	
	is_closing = true
	animation_player.play_backwards("default")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	self.get_tree().paused = false
	self.queue_free()
	


func on_resume_pressed():
	close()


func on_options_pressed():
	var options_scene_instance = options_scene.instantiate()
	self.add_child(options_scene_instance)
	options_scene_instance.back_pressed.connect(on_options_back_pressed.bind(options_scene_instance))


func on_quit_pressed():
	self.get_tree().paused = false
	self.get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func on_options_back_pressed(options_menu: Node):
	options_menu.queue_free()
