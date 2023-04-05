extends Control

var ability_decorator_progress_bar = preload("res://scenes/ui/ability_decorator_progress_bar.tscn")

@onready var quantity_label = %QuantityLabel
@onready var cooldown_progress_bar = %CooldownProgressBar
@onready var icon_sprite = %IconSprite
@onready var decorator_container = %DecoratorContainer

var ability_controller: AbilityController


func _ready():
	for c in decorator_container.get_children():
		c.queue_free()


func _process(delta):
	update_cooldown_progress()


func set_ability_controller(controller: AbilityController):
	ability_controller = controller
	controller.upgraded.connect(on_ability_upgraded)
	controller.decorator_added.connect(on_decorator_added)
	update_view()


func update_view():
	if !ability_controller:
		return
	
	icon_sprite.texture = ability_controller.spell_ability_resource.icon
	
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
		cooldown_progress_bar.get("theme_override_styles/fill").set_bg_color(Color.html("#75e3ff"))
	else:
		cooldown_progress_bar.get("theme_override_styles/fill").set_bg_color(Color.html("#8b9bb4"))


func on_ability_upgraded():
	update_view()


func on_decorator_added(decorator_controller: AbilityControllerDecorator):
	# Insert new node to the top
	var children = decorator_container.get_children()
	for c in children:
		decorator_container.remove_child(c)
	
	var progress_bar = ability_decorator_progress_bar.instantiate()
	decorator_container.add_child(progress_bar)
	progress_bar.set_resource(decorator_controller.spell_decorator_resource)
	
	for c in children:
		decorator_container.add_child(c)
