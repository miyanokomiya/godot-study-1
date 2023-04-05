extends HBoxContainer

@onready var progress_bar = $ProgressBar
@onready var timer = $Timer


func _ready():
	timer.timeout.connect(on_timer_timeout)


func set_timeout(timeout: float):
	timer.wait_time = timeout
	timer.start()
	var tween = create_tween()
	progress_bar.value = 1.0
	tween.tween_property(progress_bar, "value", 0.0, timeout)


func set_fill(color: Color):
	progress_bar.get("theme_override_styles/fill").set_bg_color(color)


func on_timer_timeout():
	self.queue_free()
