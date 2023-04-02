extends Control

@onready var name_label = %NameLabel
@onready var cooldown_progress_bar = %CooldownProgressBar

var ability_controller: AbilityController


func _process(delta):
	update_cooldown_progress()


func set_ability_controller(controller: AbilityController):
	ability_controller = controller
	name_label.text = controller.get_ability_name()


func update_cooldown_progress():
	if !ability_controller:
		return
	
	cooldown_progress_bar.value = 1.0 - clamp(ability_controller.get_current_cooldown_time() / ability_controller.get_cooldown_time(), 0.0, 1.0)
	if cooldown_progress_bar.value == 1.0:
		cooldown_progress_bar.get("theme_override_styles/fill").set_border_color(Color.html("#75e3ff"))
	else:
		cooldown_progress_bar.get("theme_override_styles/fill").set_border_color(Color.html("#8b9bb4"))
