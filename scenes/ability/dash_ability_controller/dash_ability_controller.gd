extends AbilityController

@onready var dash_component = $DashComponent


func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	dash_component.finished.connect(on_dash_finished)
	dash_component.set_cooldown_time(get_cooldown_time())


func _process(delta):
	if Input.is_action_just_pressed("dash") && dash_component.can_dash():
		var player = self.get_tree().get_first_node_in_group("player") as Node2D
		if player == null:
			return
		
		player.velocity_component.is_dashing = true
		dash_component.start_dash(player, player.sprite_2d, 1.2 * self.quantity)


func get_ability_name() -> String:
	return "Dash"


func get_cooldown_time() -> float:
	return dash_component.cooldown_time


func get_current_cooldown_time() -> float:
	return dash_component.get_current_cooldown_time()



func on_ability_upgrade_added(upgrade: AbilityUpgrade, upgrade_manager: UpgradeManager):
	pass


func on_dash_finished():
	var player = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	player.velocity_component.is_dashing = false
	dash_component.set_cooldown_time(get_cooldown_time())
