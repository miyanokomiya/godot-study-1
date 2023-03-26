extends Node

var current_experienct = 0


func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func increment_experience(number: float):
	current_experienct += number
	print(current_experienct)


func on_experience_vial_collected(number: float):
	increment_experience(number)
