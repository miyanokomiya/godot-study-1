extends CanvasLayer

const SAVE_FILE_PATH = "user://options.save"

signal back_pressed

@onready var window_button: Button = %WindowButton
@onready var sfx_slider = %SfxSlider
@onready var music_slider = %MusicSlider
@onready var back_button = %BackButton

var save_data: Dictionary = {
	"sfx": 0.8,
	"music": 0.8,
}


func _ready():
	back_button.pressed.connect(on_back_pressed)
	window_button.pressed.connect(on_window_button_pressed)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("music"))
	load_save_file()
	apply_save_data()
	update_display()


func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func apply_save_data():
	if save_data.has("sfx"):
		set_bus_volume_pcercent("sfx", save_data["sfx"])
	
	if save_data.has("music"):
		set_bus_volume_pcercent("music", save_data["music"])


func update_display():
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"
	
	sfx_slider.value = get_bus_volume_pcercent("sfx")
	music_slider.value = get_bus_volume_pcercent("music")


func get_bus_volume_pcercent(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_pcercent(bus_name: String, percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	save_data[bus_name] = percent


func on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	
	update_display()


func on_audio_slider_changed(value: float, bus_name: String):
	set_bus_volume_pcercent(bus_name, value)


func on_back_pressed():
	save()
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	back_pressed.emit()
