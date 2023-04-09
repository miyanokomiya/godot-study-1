extends AbilityControllerDecorator


func decorate_cooldown_time(cooldown: float) -> float:
	return cooldown * 0.9
