extends CanvasLayer


signal back_pressed

@onready var window_button: Button = %WindowButton
@onready var sfx_slider = %SfxSlider
@onready var music_slider = %MusicSlider
@onready var back_button = %BackButton


func _ready():
	back_button.pressed.connect(on_back_pressed)
	window_button.pressed.connect(on_window_button_pressed)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("music"))
	update_display()


func update_display():
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"
	
	sfx_slider.value = OptionManager.get_bus_volume_pcercent("sfx")
	music_slider.value = OptionManager.get_bus_volume_pcercent("music")


func on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	
	update_display()


func on_audio_slider_changed(value: float, bus_name: String):
	OptionManager.set_bus_volume_pcercent(bus_name, value)
	update_display()


func on_back_pressed():
	OptionManager.save()
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	back_pressed.emit()
