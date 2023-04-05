extends HBoxContainer

@onready var timer = $Timer
@onready var icon_texture_rect = %IconTextureRect
@onready var progress_bar = %ProgressBar


func _ready():
	timer.timeout.connect(on_timer_timeout)


func set_resource(resource: SpellDecoratorResource):
	icon_texture_rect.texture = resource.icon
	if resource.timeout > 0:
		timer.wait_time = resource.timeout
		timer.start()
		var tween = create_tween()
		progress_bar.value = 1.0
		tween.tween_property(progress_bar, "value", 0.0, resource.timeout)
		progress_bar.get("theme_override_styles/fill").set_bg_color(resource.color)
	else:
		progress_bar.hide()


func on_timer_timeout():
	self.queue_free()
