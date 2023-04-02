extends Node

@onready var trigger_timer = $TriggerTimer

@export var trigger_timeout: int = 30
@export var velocity_component: Node

func _ready():
	trigger_timer.timeout.connect(on_trigger_timer_timeout)
	trigger_timer.wait_time = trigger_timeout
	trigger_timer.start()


func on_trigger_timer_timeout():
	velocity_component.max_speed *= 4
	velocity_component.acceleration *= 2
