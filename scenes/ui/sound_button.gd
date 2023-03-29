extends Button

@onready var random_stream_player_component = $RandomStreamPlayerComponent


func _ready():
	pressed.connect(on_pressed)


func on_pressed():
	random_stream_player_component.play_random()
