extends Node

const SAVE_FILE_PATH = "user://options.save"

var save_data: Dictionary = {
	"sfx": 0.8,
	"music": 0.8,
}


func _ready():
	load_save_file()
	apply_save_data()


func apply_save_data():
	set_bus_volume_pcercent("sfx", get_bus_volume_pcercent("sfx"))
	set_bus_volume_pcercent("music", get_bus_volume_pcercent("music"))


func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func get_bus_volume_pcercent(bus_name: String) -> float:
	if save_data.has(bus_name):
		return save_data[bus_name]
	
	return 0.8


func set_bus_volume_pcercent(bus_name: String, value: float) -> void:
	save_data[bus_name] = value
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
