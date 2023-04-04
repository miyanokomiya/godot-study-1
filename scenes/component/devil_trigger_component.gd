extends Node

@onready var trigger_timer = $TriggerTimer

@export var trigger_timeout: int = 60
@export var velocity_component: Node

func _ready():
	trigger_timer.timeout.connect(on_trigger_timer_timeout)
	trigger_timer.wait_time = trigger_timeout
	trigger_timer.start()


func on_trigger_timer_timeout():
	velocity_component.max_speed *= 3
	velocity_component.acceleration *= 1.5
