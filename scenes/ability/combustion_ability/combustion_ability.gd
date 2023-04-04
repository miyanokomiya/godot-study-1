extends SpellAbility

@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var hitbox_component = $HitboxComponent


func _ready():
	timer.timeout.connect(on_timer_timeout)


func set_lifetime(time: float):
	timer.wait_time = time
	timer.start()


func on_timer_timeout():
	animation_player.play("fade_out")
