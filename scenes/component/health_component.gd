extends Node
class_name HealthComponent

signal died
signal health_decreased(diff: float)
signal health_increased(diff: float)
signal health_changed

@export var max_health: float = 10
@export var prevent_queue_free: bool = false

var current_health: float


func _ready():
	current_health = max_health


func damage(damage_amount: float):
	current_health = clamp(current_health - damage_amount, 0, max_health)
	health_changed.emit()
	if damage_amount > 0:
		health_decreased.emit(-damage_amount)
	else:
		health_increased.emit(damage_amount)
		
	Callable(check_death).call_deferred()


func heal(heal_amount: float):
	damage(-heal_amount)


func get_health_percent() -> float:
	if max_health <= 0:
		return 0
	
	return min(current_health / max_health, 1)


func check_death():
	if is_died():
		died.emit()
		if !prevent_queue_free:
			self.owner.queue_free()


func is_died() -> bool:
	return current_health == 0
