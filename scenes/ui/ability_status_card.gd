extends Control

@onready var name_label = %NameLabel
@onready var quantity_label = %QuantityLabel
@onready var cooldown_progress_bar = %CooldownProgressBar
@onready var icon_sprite_2d = %IconSprite2D

var ability_controller: AbilityController


func _process(delta):
	update_cooldown_progress()


func set_ability_controller(controller: AbilityController):
	ability_controller = controller
	controller.upgraded.connect(on_ability_upgraded)
	update_view()


func update_view():
	if !ability_controller:
		return
	
	if ability_controller.icon:
		name_label.text = ""
		icon_sprite_2d.texture = ability_controller.icon
		icon_sprite_2d.show()
	else:
		name_label.text = ability_controller.get_ability_name()
		icon_sprite_2d.hide()
	
	if ability_controller.quantity > 1:
		quantity_label.text = "x%d" % ability_controller.quantity
		quantity_label.show()
	else:
		quantity_label.text = ""
		quantity_label.hide()
	
	if !ability_controller.executable:
		cooldown_progress_bar.hide()


func update_cooldown_progress():
	if !ability_controller || !ability_controller.executable:
		return
	
	cooldown_progress_bar.value = 1.0 - clamp(ability_controller.get_current_cooldown_time() / ability_controller.get_cooldown_time(), 0.0, 1.0)
	if cooldown_progress_bar.value == 1.0:
		cooldown_progress_bar.get("theme_override_styles/fill").set_border_color(Color.html("#75e3ff"))
	else:
		cooldown_progress_bar.get("theme_override_styles/fill").set_border_color(Color.html("#8b9bb4"))


func on_ability_upgraded():
	update_view()
