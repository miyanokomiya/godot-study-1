extends Node

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

const TARGET_EXPERIENCE_GROWTH = 4

var current_experienct = 0
var current_level = 1
var target_experience = 1


func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func increment_experience(number: float):
	current_experienct = min(current_experienct + number, target_experience)
	experience_updated.emit(current_experienct, target_experience)
	if current_experienct == target_experience:
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_experienct = 0
		experience_updated.emit(current_experienct, target_experience)
		level_up.emit(current_level)

func on_experience_vial_collected(number: float):
	increment_experience(number)
