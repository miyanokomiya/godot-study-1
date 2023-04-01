extends AbilityController

@onready var dash_component = $DashComponent


func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	dash_component.finished.connect(on_dash_finished)


func _process(delta):
	if Input.is_action_just_pressed("dash") && dash_component.can_dash():
		var player = self.get_tree().get_first_node_in_group("player") as Node2D
		if player == null:
			return
		
		player.velocity_component.is_dashing = true
		dash_component.start_dash(player, player.sprite_2d, 0.2)


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	pass


func on_dash_finished():
	var player = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	player.velocity_component.is_dashing = false
